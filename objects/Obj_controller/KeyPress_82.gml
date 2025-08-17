/// Obj_controller : Key Press <R> — 안전 스위치
var n = instance_number(Obj_cat_parent);
if (n < 2) exit; // 고양이 1마리 이하면 그냥 무시(에러 없음)

var cur = (variable_global_exists("current_player") && instance_exists(global.current_player))
    ? global.current_player
    : noone;

// current_player가 유효하지 않으면 아무나 한 마리 세팅하고 끝
if (cur == noone) {
    if (n > 0) global.current_player = instance_find(Obj_cat_parent, 0);
    exit;
}

// 현재 인덱스 찾고 다음 인덱스로 스위치
var idx = -1;
for (var i = 0; i < n; i++) {
    if (instance_find(Obj_cat_parent, i) == cur) { idx = i; break; }
}
var next = instance_find(Obj_cat_parent, (idx + 1) mod n);
if (instance_exists(next)) {
    global.current_player = next;
    // (선택) 카메라가 따라가게 쓰는 변수가 있으면 여기서 갱신
    // camera_target = next;
}
