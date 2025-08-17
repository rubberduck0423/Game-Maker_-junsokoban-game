event_inherited();

/// Obj_blue_button : Create
pressed = false;
press_grace = 2;
_press_timer = 0;

// 채널
channel_id = 1;

// 스프라이트(둘 중 프로젝트에 맞는 쪽만 실제로 존재할 것)
spr_up   = Spr_button_blue_up;   // ← 여기서 최종적으로 맞는 리소스만 남겨도 됨
spr_down = Spr_button_blue_down;

sprite_index = spr_up;
image_speed  = 0;

reset = function () {
    _reset_base();
    pressed = false;
    sprite_index = spr_up;   // ← 하드코딩 대신 변수 사용
    image_index  = 0;
    image_speed  = 0;
};
