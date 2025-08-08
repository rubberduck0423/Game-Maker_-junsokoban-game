//----------------------------------
// 기본 방향 · 스프라이트
dir          = "down";
sprite_index = Spr_black_cat_front_stop;  // STOP도 4프레임 · 5 fps
image_index  = 0;                         // Idle 첫 프레임

//----------------------------------
// 이동·격자 설정
move_speed = 4;     // 4 px/Step  → 32 px을 8 Step에 이동
grid       = 32;    // 한 칸 크기

//----------------------------------
// 예약-큐(남은 픽셀) 초기화
queue_dx   = 0;
queue_dy   = 0;
moving     = false; // 현재 보간 중인지 여부

// 격자 정렬(권장)
x = round(x/32)*32;
y = round(y/32)*32;