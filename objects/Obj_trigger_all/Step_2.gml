/// Obj_trigger_all : End Step  (E키 인터랙션, 비그룹 + 그룹 모두 지원)
if (exit_lock || target_room == noone) exit;

// ── 공통: 이 인스턴스의 트리거 영역(좌하단 기준)
var left   = x;
var bottom = y;
var right  = left + grid_w * tile;
var top    = bottom - grid_h * tile;

// ── 헬퍼: 주어진 인스턴스의 '발 셀 중심'이 사각형 안인가? (경계 포함)
function _in_rect_foot(_inst, _l, _t, _r, _b) {
    var grid   = 32;
    var foot_x = (_inst.bbox_left + _inst.bbox_right) * 0.5;
    var foot_y = _inst.bbox_bottom;
    var cell_x = floor(foot_x / grid) * grid + grid * 0.5;
    var cell_y = floor(foot_y / grid) * grid + grid * 0.5;
    return (cell_x >= _l && cell_x <= _r && cell_y >= _t && cell_y <= _b);
}

// ── 비그룹: 한 덩어리(이 인스턴스 영역) 안에 '두 마리' + E키
if (!mode_group) {
    var count = 0;
    var cur_in = false;

    var nCats = instance_number(Obj_cat_parent);
    for (var i = 0; i < nCats; i++) {
        var c = instance_find(Obj_cat_parent, i);
        if (_in_rect_foot(c, left, top, right, bottom)) {
            count += 1;
            if (variable_global_exists("current_player") && instance_exists(global.current_player)) {
                if (c == global.current_player) cur_in = true;
            } else cur_in = true;
        }
    }

    if (keyboard_check_pressed(ord("E")) && cur_in && count >= 2) {
        exit_lock = true;
        room_goto(target_room);
    }
}
// ── 그룹: 같은 channel_id의 모든 트리거 각각에 '한 마리 이상' + (현재 조작자 어느 칸 안) + E키
else {
    // 외부(현재 인스턴스)에 누적(인스턴스 변수로 둬야 with 안에서 수정 가능)
    _group_all_ok     = true;   // 매 프레임 리셋
    _group_cur_in_any = false;

    with (Obj_trigger_all) {
        if (channel_id == other.channel_id) {
            var l = x;
            var b = y;
            var r = l + grid_w * tile;
            var t = b - grid_h * tile;

            // 이 칸 안의 고양이 수 & 현재 조작자 여부
            var cnt = 0;
            var cur_here = false;

            var nCats2 = instance_number(Obj_cat_parent);
            for (var j = 0; j < nCats2; j++) {
                var cat = instance_find(Obj_cat_parent, j);
                if (other._in_rect_foot(cat, l, t, r, b)) {
                    cnt += 1;
                    if (variable_global_exists("current_player") && instance_exists(global.current_player)) {
                        if (cat == global.current_player) cur_here = true;
                    } else cur_here = true;
                }
            }

            if (cnt < 1) other._group_all_ok = false; // 이 트리거 칸이 비어있으면 실패
            if (cur_here) other._group_cur_in_any = true; // 조작자가 어느 한 칸엔 들어와 있어야
        }
    }

    if (keyboard_check_pressed(ord("E")) && _group_cur_in_any && _group_all_ok) {
        exit_lock = true;
        room_goto(target_room);
    }
}
