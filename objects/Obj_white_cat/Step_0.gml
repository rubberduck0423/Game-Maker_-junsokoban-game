
if (id != global.current_player) exit;   // 선택되지 않았으면 코드 종료


//----------------------------------
// 1) 입력 → 32 px 예약 (이동 중 아닐 때만)
if (!moving && queue_dx == 0 && queue_dy == 0)
{
    var dx32 = 0, dy32 = 0;

    if (keyboard_check(ord("W"))) { dy32 = -grid; dir = "up";    }
    else if (keyboard_check(ord("S"))) { dy32 =  grid; dir = "down";  }
    else if (keyboard_check(ord("A"))) { dx32 = -grid; dir = "left";  }
    else if (keyboard_check(ord("D"))) { dx32 =  grid; dir = "right"; }

    if (dx32 != 0 || dy32 != 0)  // 예약이 생겼을 때만
    {
        // ① 걷기 스프라이트로 전환 (방향이 바뀔 때만 image_index 리셋)
        var walk_sprite;
        switch (dir) {
            case "up":    walk_sprite = Spr_white_cat_back_walking;   break;
            case "down":  walk_sprite = Spr_white_cat_front_walking;  break;
            case "left":  walk_sprite = Spr_white_cat_left_walking;   break;
            case "right": walk_sprite = Spr_white_cat_right_walking;  break;
        }
        if (sprite_index != walk_sprite) {
            sprite_index = walk_sprite;
            image_index  = 0;        // 새 방향일 때만 0부터
        }

        // ② 예약 큐 누적 & 이동 시작
        queue_dx += dx32;
        queue_dy += dy32;
        moving    = true;
    }
}

//----------------------------------
// 2) 예약분 만큼 보간 이동
if (moving)
{
    // X축
    if (queue_dx != 0) {
        var step_x = clamp(queue_dx, -move_speed, move_speed);
        x       += step_x;
        queue_dx -= step_x;
    }
    // Y축
    if (queue_dy != 0) {
        var step_y = clamp(queue_dy, -move_speed, move_speed);
        y       += step_y;
        queue_dy -= step_y;
    }

    // 예약 소진 → 이동 종료
    if (queue_dx == 0 && queue_dy == 0)
        moving = false;
}

//----------------------------------
// 3) 완전히 멈췄을 때만 STOP 스프라이트로 전환
var anyKey = keyboard_check(ord("W")) || keyboard_check(ord("A"))
          || keyboard_check(ord("S")) || keyboard_check(ord("D"));

if (!moving && queue_dx == 0 && queue_dy == 0 && !anyKey)
{
    var stop_sprite;
    switch (dir) {
        case "up":    stop_sprite = Spr_white_cat_back_stop;   break;
        case "down":  stop_sprite = Spr_white_cat_front_stop;  break;
        case "left":  stop_sprite = Spr_white_cat_left_stop;   break;
        case "right": stop_sprite = Spr_white_cat_right_stop;  break;
    }
    if (sprite_index != stop_sprite) {
        sprite_index = stop_sprite;
        image_index  = 0;      // Idle 첫 프레임
    }
    // image_speed는 편집기 Speed=5 fps 그대로 유지
}
