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

// [ADD] 닫힌 상태 bbox를 고정 저장(이 좌표로만 스캔)
door_l = bbox_left;
door_t = bbox_top;
door_r = bbox_right;
door_b = bbox_bottom;


// 버튼-문 매칭(기본: 채널 0)
channel_id = 0;

// 디버그 표시 토글(원하면 true로)
debug_draw = false;

/// Obj_door : Create (추가) — 이 문과 겹치는 벽 캐시
walls_hit = [];
{
    var L = ds_list_create();
    var n = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom,
                                     Obj_wall, false, true, L, true);
    for (var i = 0; i < n; i++) {
        array_push(walls_hit, L[| i]);
    }
    ds_list_destroy(L);
}

/// Obj_door : Create  (추가 - 즉시 스캔 on/off 유틸)

// [CHANGE] enable
walls_enable_now = function () {
    var L = ds_list_create();
    var n = collision_rectangle_list(door_l, door_t, door_r, door_b,   // ← 여기!
                                     Obj_wall, false, true, L, true);
    for (var i = 0; i < n; i++) {
        var w = L[| i];
        with (w) { active = true;  visible = true; }
    }
    ds_list_destroy(L);
};

// [CHANGE] disable
walls_disable_now = function () {
    var L = ds_list_create();
    var n = collision_rectangle_list(door_l, door_t, door_r, door_b,   // ← 여기!
                                     Obj_wall, false, true, L, true);
    for (var i = 0; i < n; i++) {
        var w = L[| i];
        with (w) { active = false; visible = false; }
    }
    ds_list_destroy(L);
};
