//----------------------------------------------
// 1) 방향키 입력 상태 미리 읽기
var kU = keyboard_check(ord("W"));
var kD = keyboard_check(ord("S"));
var kL = keyboard_check(ord("A"));
var kR = keyboard_check(ord("D"));
var anyKey = kU || kD || kL || kR;

//----------------------------------------------
// 2) 이동 중이면 좌표 보간 (32px 목표까지 이동)
if (moving)
{
    if (x < target_x) x = min(x + move_speed, target_x);
    if (x > target_x) x = max(x - move_speed, target_x);
    if (y < target_y) y = min(y + move_speed, target_y);
    if (y > target_y) y = max(y - move_speed, target_y);

    // 목표 칸 도착 → 아직 stop 출력은 하지 않음
    if (x == target_x && y == target_y)
        moving = false;
}

//----------------------------------------------
// 3) 이동 중이 아닐 때 (moving == false)
if (!moving)
{
    //--------------------------------------------------
    // (A) 새 방향키가 눌리면 즉시 다음 칸 이동 시작
    if (kU)
    {
        dir = "up";
        target_x = x;
        target_y = y - 32;
        sprite_index = Spr_black_cat_back_walking;
        moving = true;
    }
    else if (kD)
    {
        dir = "down";
        target_x = x;
        target_y = y + 32;
        sprite_index = Spr_black_cat_front_walking;
        moving = true;
    }
    else if (kL)
    {
        dir = "left";
        target_x = x - 32;
        target_y = y;
        sprite_index = Spr_black_cat_left_walking;
        moving = true;
    }
    else if (kR)
    {
        dir = "right";
        target_x = x + 32;
        target_y = y;
        sprite_index = Spr_black_cat_right_walking;
        moving = true;
    }

    // 걷기 애니메이션 속도 계산 (스프라이트 프레임 수 / 이동 스텝 수)
    if (moving)
    {
        var frames = sprite_get_number(sprite_index);   // 예: 4
        var steps  = 32 / move_speed;                   // 예: 16
        image_speed = frames / steps;                   // 4 / 16 = 0.25 → 15 fps
        image_index = 0;
    }
    //--------------------------------------------------
    // (B) 키가 전혀 눌려 있지 않을 때만 stop 스프라이트 적용
    else if (!anyKey)
    {
        switch (dir)
        {
            case "up":    sprite_index = Spr_black_cat_back_stop;   break;
            case "down":  sprite_index = Spr_black_cat_front_stop;  break;
            case "left":  sprite_index = Spr_black_cat_left_stop;   break;
            case "right": sprite_index = Spr_black_cat_right_stop;  break;
        }
        image_speed = 0;
        image_index = 0;
    }
}
