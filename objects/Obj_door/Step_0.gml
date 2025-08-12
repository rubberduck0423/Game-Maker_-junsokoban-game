/// Obj_door : Step
// 1) 동일 channel_id의 버튼 중 하나라도 눌렸는지 집계 (OR 로직)
var want_open = false;
with (Obj_button) {
    if (channel_id == other.channel_id && pressed) {
        want_open = true;
    }
}

// 2) 상태 머신
switch (state) {

    case DoorState.CLOSED:
        if (want_open) {
            state        = DoorState.OPENING;
            sprite_index = spr_opening;
            image_index  = 0;
            image_speed  = 1; // (스프라이트 리소스가 FPS=5일 때 1배속)
        }
    break;

    case DoorState.OPENING:
        if (!want_open) {
            // 열리던 중 해제 → 닫기 시작
            state        = DoorState.CLOSING;
            sprite_index = spr_closing;
            image_index  = 0;
            image_speed  = 1;

            // 닫히기 시작 프레임: 즉시 차단 복구
            walls_enable_now();

        } else {
            // 끝 프레임 도달 시 열린 상태로 정지
            if (image_index >= image_number - 1) {
                state        = DoorState.OPEN_HOLD;
                image_index  = image_number - 1;
                image_speed  = 0; // 마지막 프레임 고정(열림 유지)

                // 완전 열림 진입: 통행 허용
                walls_disable_now();
            }
        }
    break;

    case DoorState.OPEN_HOLD:
        if (!want_open) {
            // 버튼 해제 → 닫기 시작
            state        = DoorState.CLOSING;
            sprite_index = spr_closing;
            image_index  = 0;
            image_speed  = 1;

            // 버튼 떼는 프레임: 즉시 차단 복구
            walls_enable_now();
        }
        // 계속 누르면 유지
    break;

    case DoorState.CLOSING:
        if (want_open) {
            // 닫히는 중 재누름 → 다시 열기(반전)
            state        = DoorState.OPENING;
            sprite_index = spr_opening;
            image_index  = 0;
            image_speed  = 1;
            // 차단은 열림 완주 시점(OPEN_HOLD 진입)에서 해제
        } else {
            // 닫기 애니메이션 완주 시 완전히 닫힘
            if (image_index >= image_number - 1) {
                state        = DoorState.CLOSED;
                sprite_index = spr_closed;
                image_index  = 0;
                image_speed  = 0;

                // 안전망: 닫힘 완료에도 차단 유지
                walls_enable_now();
            }
        }
    break;
}
