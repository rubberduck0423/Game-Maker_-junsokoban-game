/// Obj_controller : Room Start

// 1) current_player 선정(있으면 유지, 없으면 찾아서 대입)
if (!variable_global_exists("current_player")) global.current_player = noone;

if (!instance_exists(global.current_player)) {
    var p = noone;
    if (instance_exists(Obj_black_cat))  p = instance_find(Obj_black_cat, 0);
    if (p == noone && instance_exists(Obj_white_cat)) p = instance_find(Obj_white_cat, 0);
    global.current_player = p;
}

// 2) (옵션) 카메라 추적 대상 동기화
if (variable_instance_exists(id, "target"))        target        = global.current_player;
if (variable_instance_exists(id, "follow"))        follow        = global.current_player;
if (variable_instance_exists(id, "follow_target")) follow_target = global.current_player;

// 3) indicator 생성/재설치 — ★여기로 이동★
if (!instance_exists(Obj_where) && instance_exists(global.current_player)) {
    var lay = layer_exists("Instances") ? layer_get_id("Instances") : layer;
    var ind = instance_create_layer(global.current_player.x, global.current_player.y, lay, Obj_where);
    // 필요하면 ind에 추적 대상 지정:
    if (variable_instance_exists(ind, "owner")) ind.owner = global.current_player;
}
