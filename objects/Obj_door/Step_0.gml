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
            state = DoorState.OPENING;
            sprite_index = spr_opening;
            // 스프라이트의 재생 속도는 리소스에서 FPS=5로 설정했다고 가정
            image_index = 0;
            image_speed = 1; // (FPS 모드 기준 1.0배속)
        }
    break;

    case DoorState.OPENING:
        if (!want_open) {
            // 열리던 중에 해제 → 닫기 시작
            state = DoorState.CLOSING;
            sprite_index = spr_closing;
            image_index = 0;
            image_speed = 1;
        } else {
            // 끝 프레임 도달 시 열린 상태로 정지
            if (image_index >= image_number - 1) {
                state = DoorState.OPEN_HOLD;
                image_index = image_number - 1;
                image_speed = 0; // 마지막 프레임 고정(열림 유지)
            }
        }
    break;

    case DoorState.OPEN_HOLD:
        if (!want_open) {
            // 버튼 해제 → 닫기 시작
            state = DoorState.CLOSING;
            sprite_index = spr_closing;
            image_index = 0;
            image_speed = 1;
        } else {
            // 계속 누르는 중이면 그대로 유지(아무 것도 안 함)
        }
    break;

    case DoorState.CLOSING:
        if (want_open) {
            // 닫히는 중 재누름 → 즉시 다시 열기(반전)
            state = DoorState.OPENING;
            sprite_index = spr_opening;
            image_index = 0;
            image_speed = 1;
        } else {
            // 닫기 애니메이션 완주 시 완전히 닫힘
            if (image_index >= image_number - 1) {
                state = DoorState.CLOSED;
                sprite_index = spr_closed;
                image_index = 0;
                image_speed = 0;
            }
        }
    break;
}
