/// Obj_button : Create
event_inherited(); // 부모(Obj_resettable_parent) 초기화 먼저

pressed      = false;
press_grace  = 2;
_press_timer = 0;

// 채널(기본 버튼은 보통 0)
channel_id = 0;

// ── 스프라 캐시(이름 변경에 안전하게)
var up_id   = asset_get_index("Spr_button_up");
spr_up      = (up_id != -1) ? up_id : sprite_index;

var down_id = asset_get_index("Spr_button_down");
if (down_id != -1) spr_down = down_id;

// 초기 외형
sprite_index = spr_up;
image_speed  = 0;

// ── reset: 캐시된 변수만 사용(하드코딩 X)
reset = function () {
    _reset_base();        // 위치/이동큐 초기화
    pressed = false;
    sprite_index = spr_up;
    image_index  = 0;
    image_speed  = 0;
};
