/// Obj_door : Create
// 상태 열거형
enum DoorState { CLOSED, OPENING, OPEN_HOLD, CLOSING }

// 리소스(스프라이트) 약속
spr_closed  = Spr_door_closed;
spr_opening = Spr_door_opening;  // 3프레임, FPS=5 (리소스 에디터에서 설정)
spr_closing = Spr_door_closing;  // 3프레임, FPS=5

// 초기 상태
state = DoorState.CLOSED;
sprite_index = spr_closed;
image_index  = 0;
image_speed  = 0;    // CLOSED는 정지

// 버튼-문 매칭(기본: 채널 0)
channel_id = 0;

// 디버그 표시 토글(원하면 true로)
debug_draw = false;
