/// Obj_controller : Room Start
// current_player가 없거나(최초) 이전 룸 인스턴스를 가리키면 재선정
if (!variable_global_exists("current_player")) global.current_player = noone;

if (!instance_exists(global.current_player)) {
    var p = noone;
    if (instance_exists(Obj_black_cat))  p = instance_find(Obj_black_cat, 0);
    if (p == noone && instance_exists(Obj_white_cat)) p = instance_find(Obj_white_cat, 0);
    global.current_player = p;
}

// (옵션) 카메라 추적 대상도 갱신 — 네 변수명에 맞춰 하나만 쓰기
if (variable_instance_exists(id, "target"))        target        = global.current_player;
if (variable_instance_exists(id, "follow"))        follow        = global.current_player;
if (variable_instance_exists(id, "follow_target")) follow_target = global.current_player;
