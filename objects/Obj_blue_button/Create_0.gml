/// Obj_blue_button : Create
pressed = false;
press_grace = 2;
_press_timer = 0;

// 채널(같은 번호끼리 같은 문과 연결)
channel_id = 1;

// 스프라이트 (파란 버튼 스프라가 따로 없으면 기존 것을 써도 됨)
spr_up   = Spr_button_blue_up;      // 또는 Spr_blue_button_up
spr_down = Spr_button_blue_down;    // 또는 Spr_blue_button_down
sprite_index = spr_up;
image_speed  = 0;
