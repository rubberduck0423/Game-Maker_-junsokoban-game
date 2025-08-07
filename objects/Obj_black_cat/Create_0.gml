// 1칸(32px) 격자 위치로 정렬
x = round(x / 32) * 32;
y = round(y / 32) * 32;

// 상태 변수
target_x   = x;
target_y   = y;
moving     = false;
dir        = "down";

// 이동·애니 속도
move_speed  = 2;           // 32px → 16 스텝
sprite_index = Spr_black_cat_front_stop;
image_speed  = 0;          // 정지 상태
