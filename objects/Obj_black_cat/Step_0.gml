//----------------------------------
// A) 방향키
var vx = 0, vy = 0;
if (keyboard_check(ord("W"))) { vy = -1; dir = "up";    }
if (keyboard_check(ord("S"))) { vy =  1; dir = "down";  }
if (keyboard_check(ord("A"))) { vx = -1; dir = "left";  }
if (keyboard_check(ord("D"))) { vx =  1; dir = "right"; }

// 대각선 보정 (원하면 삭제)
if (vx != 0 && vy != 0) { vx *= 0.7071; vy *= 0.7071; }

//----------------------------------
// B) 위치 이동
x += vx * move_speed;
y += vy * move_speed;

//----------------------------------
// C) 스프라이트 전환 (image_speed는 건드리지 않음)
if (vx != 0 || vy != 0)        // 걷는 중
{
    var want;
    switch (dir)
    {
        case "up":    want = Spr_black_cat_back_walking;   break;
        case "down":  want = Spr_black_cat_front_walking;  break;
        case "left":  want = Spr_black_cat_left_walking;   break;
        case "right": want = Spr_black_cat_right_walking;  break;
    }
    if (sprite_index != want) { sprite_index = want; image_index = 0; }
}
else                            // 멈춘 상태
{
    var want;
    switch (dir)
    {
        case "up":    want = Spr_black_cat_back_stop;   break;
        case "down":  want = Spr_black_cat_front_stop;  break;
        case "left":  want = Spr_black_cat_left_stop;   break;
        case "right": want = Spr_black_cat_right_stop;  break;
    }
    if (sprite_index != want) { sprite_index = want; image_index = 0; }
    // stop 스프라이트는 Speed가 0이므로 자동으로 프레임 고정
}
