/// Obj_blue_door : Step
// 채널 일치하는 파란 버튼 중 '눌림' 개수 집계 (AND 로직)
var pressed_count = 0;
with (Obj_blue_button) {
    if (channel_id == other.channel_id && pressed) pressed_count++;
}
var want_open = (pressed_count >= other.required_press_count);

// 상태 머신
switch (state) {
    case BlueDoorState.CLOSED:
        if (want_open) {
            state        = BlueDoorState.OPENING;
            sprite_index = spr_opening;
            image_index  = 0;
            image_speed  = 1; // 스프라 FPS=5 기준 1배속
        }
    break;

    case BlueDoorState.OPENING:
        if (!want_open) {
            state        = BlueDoorState.CLOSING;
            sprite_index = spr_closing;
            image_index  = 0;
            image_speed  = 1;
            walls_enable_now();   // 닫히기 시작 즉시 벽 ON
        } else if (image_index >= image_number - 1) {
            state        = BlueDoorState.OPEN_HOLD;
            image_index  = image_number - 1;
            image_speed  = 0;
            walls_disable_now();  // 완전 열림 진입: 벽 OFF
        }
    break;

    case BlueDoorState.OPEN_HOLD:
        if (!want_open) {
            state        = BlueDoorState.CLOSING;
            sprite_index = spr_closing;
            image_index  = 0;
            image_speed  = 1;
            walls_enable_now();   // 버튼 하나라도 떼면 즉시 벽 ON
        }
    break;

    case BlueDoorState.CLOSING:
        if (want_open) {
            state        = BlueDoorState.OPENING;  // 닫히는 중에 다시 2개 눌리면 즉시 반전
            sprite_index = spr_opening;
            image_index  = 0;
            image_speed  = 1;
        } else if (image_index >= image_number - 1) {
            state        = BlueDoorState.CLOSED;
            sprite_index = spr_closed;
            image_index  = 0;
            image_speed  = 0;
            walls_enable_now();   // 안전망
        }
    break;
}

