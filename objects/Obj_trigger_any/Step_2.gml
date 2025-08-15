/// Obj_trigger_any : End Step  (E키 인터랙션)
if (exit_lock || target_room == noone) exit;

// 트리거 영역(좌하단 기준)
var left   = x;
var bottom = y;
var right  = left + grid_w * tile;
var top    = bottom - grid_h * tile;

// 영역 내 고양이 수, '현재 조작 캐릭터'가 안에 있는가
_count  = 0;     // ← 인스턴스 변수로 사용 (self._count 와 동일)
_cur_in = false; // ← 인스턴스 변수


with (Obj_cat_parent) {
    var grid   = 32;
    var foot_x = (bbox_left + bbox_right) * 0.5;
    var foot_y = bbox_bottom;
    var cell_x = floor(foot_x / grid) * grid + grid * 0.5;
    var cell_y = floor(foot_y / grid) * grid + grid * 0.5;

    if (cell_x > left && cell_x < right && cell_y > top && cell_y < bottom) {
        other._count += 1;
        if (variable_global_exists("current_player") && instance_exists(global.current_player)) {
            if (id == global.current_player) other._cur_in = true;
        } else {
            other._cur_in = true; // current_player가 없으면 허용
        }
    }
}

// ★ E키 눌렀을 때만 발동
if (keyboard_check_pressed(ord("E")) && _cur_in && _count >= 1) {
    exit_lock = true;
    room_goto(target_room);
}
