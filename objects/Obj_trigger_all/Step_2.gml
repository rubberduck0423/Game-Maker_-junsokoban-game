/// Obj_trigger_all : End Step   // ← 통째로 교체 (group 모드 안 쓰는 기본형)
if (exit_lock || target_room == noone) exit;

// 영역(좌하단 기준)
var left   = x;
var bottom = y;
var right  = left + grid_w * tile;
var top    = bottom - grid_h * tile;

// 영역 내 고양이 수, 그리고 '현재 조작 중인 고양이'가 안에 있는가
var count  = 0;
var cur_in = false;

with (Obj_cat_parent) {
    var grid = 32;
    var foot_x = (bbox_left + bbox_right) * 0.5;
    var foot_y = bbox_bottom;
    var cell_x = floor(foot_x / grid) * grid + grid * 0.5;
    var cell_y = floor(foot_y / grid) * grid + grid * 0.5;

    if (cell_x > left && cell_x < right
&&  cell_y > top  && cell_y < bottom) {
        other.count += 1;
        if (variable_global_exists("current_player") && instance_exists(global.current_player)) {
            if (id == global.current_player) other.cur_in = true;
        } else {
            other.cur_in = true;
        }
    }
}

// E키를 '누른 순간' + 현재 조작 고양이가 존 안에 있고 + 두 마리 모두 안에 있을 것
if (keyboard_check_pressed(ord("E")) && cur_in && count >= 2) {
    exit_lock = true;
    room_goto(target_room);
}
