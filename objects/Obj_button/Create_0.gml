/// Obj_button : Create
// 접촉 상태
pressed = false;

// 바운스(깜빡임) 방지용 그레이스 타임(프레임)
press_grace = 2;
_press_timer = 0;

// 스프라이트 기본값
sprite_index = Spr_button_up;
image_speed = 0; // 버튼은 고정 이미지 가정

// (미래 확장용) 채널 아이디 — 나중에 문과 매칭할 때 쓸 수 있음
channel_id = 0;
