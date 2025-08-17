event_inherited();

/// Obj_blue_door : Create
enum BlueDoorState { CLOSED, OPENING, OPEN_HOLD, CLOSING }

// 스프라이트(파란 문 전용)
spr_closed  = Spr_blue_door_closed;
spr_opening = Spr_blue_door_opening; // 3프, FPS=5
spr_closing = Spr_blue_door_closing; // 3프, FPS=5

state        = BlueDoorState.CLOSED;
sprite_index = spr_closed;
image_index  = 0;
image_speed  = 0;

// 채널 & 요구 버튼 개수(AND)
channel_id           = 1;
required_press_count = 2;   // ← 동시에 2개 눌려야 열림

debug_draw = false;

// [중요] 닫힘 상태 bbox를 고정 저장(이 좌표로만 벽 on/off 스캔)
door_l = bbox_left; door_t = bbox_top; door_r = bbox_right; door_b = bbox_bottom;

// 벽 on/off 유틸(고정 사각형으로 스캔)
walls_enable_now = function () {
    var L = ds_list_create();
    var n = collision_rectangle_list(door_l, door_t, door_r, door_b, Obj_wall, false, true, L, true);
    for (var i = 0; i < n; i++) with (L[| i]) { active = true;  visible = true; }
    ds_list_destroy(L);
};
walls_disable_now = function () {
    var L = ds_list_create();
    var n = collision_rectangle_list(door_l, door_t, door_r, door_b, Obj_wall, false, true, L, true);
    for (var i = 0; i < n; i++) with (L[| i]) { active = false; visible = false; }
    ds_list_destroy(L);
};



reset = function () {
    _reset_base();

    state        = DoorState.CLOSED;
    sprite_index = Spr_blue_door_closed;
    image_index  = 0; image_speed = 0;

    if (variable_instance_exists(id, "walls_enable_now")) walls_enable_now();
    if (variable_instance_exists(id, "block_spawn"))     block_spawn();
};
