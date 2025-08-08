// 선택 안 됐으면 종료. 단, 이미 moving 중이면 계속 움직이게 허용
if (!variable_global_exists("current_player")) exit;
if (id != global.current_player && !moving) exit;

var g = self.grid;    // ← Step 전역에서 쓸 로컬 별칭


/// 앞면 전체(가로/세로 n칸) 한 칸 앞이 비었는지 검사
function box_edge_clear(_box, _dx32, _dy32) {
    var grid = 32;
    var w = (_box.size_w != undefined) ? _box.size_w : 1;
    var h = (_box.size_h != undefined) ? _box.size_h : 1;
    var half = grid * 0.5 - 1;

    // 박스가 점유 중인 '맨 왼쪽/맨 위' 셀 중심
    var left_c = floor(_box.bbox_left / grid) * grid + grid*0.5;
    var top_c  = floor(_box.bbox_top  / grid) * grid + grid*0.5;

    if (_dx32 != 0) {
        var lead_x = (_dx32 > 0) ? left_c + (w-1)*grid : left_c;
        for (var j = 0; j < h; j++) {
            var cx = lead_x + _dx32;
            var cy = top_c + j*grid;
            var l = cx - half, t = cy - half, r = cx + half, b = cy + half;
            if (collision_rectangle(l,t,r,b, Obj_wall,        false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_box_parent,  false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_cat_parent,  false, true)) return false;
        }
    } else {
        var lead_y = (_dy32 > 0) ? top_c + (h-1)*grid : top_c;
        for (var i = 0; i < w; i++) {
            var cx = left_c + i*grid;
            var cy = lead_y + _dy32;
            var l = cx - half, t = cy - half, r = cx + half, b = cy + half;
            if (collision_rectangle(l,t,r,b, Obj_wall,        false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_box_parent,  false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_cat_parent,  false, true)) return false;
        }
    }
    return true;
}


// 1) 입력 → 32 px 예약 (이동 중 아닐 때만)
if (!moving && queue_dx == 0 && queue_dy == 0)
{
    // --- 방향 결정 ---
    var dx32 = 0, dy32 = 0;
    if (keyboard_check(ord("W"))) { dy32 = -g; dir = "up";    }
    else if (keyboard_check(ord("S"))) { dy32 =  g; dir = "down";  }
    else if (keyboard_check(ord("A"))) { dx32 = -g; dir = "left";  }
    else if (keyboard_check(ord("D"))) { dx32 =  g; dir = "right"; }

    if (dx32 != 0 || dy32 != 0)
    {
        // --- 내 '발' 위치 → 내가 서 있는 셀 중심 → 앞칸 중심 ---
        var foot_x = (bbox_left + bbox_right) * 0.5;
        var foot_y = bbox_bottom;

        var cell_x = floor(foot_x / g) * g + g * 0.5;
        var cell_y = floor(foot_y / g) * g + g * 0.5;

        var fx  = cell_x + dx32;   // 앞칸 중심
        var fy  = cell_y + dy32;

        // --- 앞칸 32x32 사각형 생성(테두리 여유 1px) ---
        var half = g * 0.5 - 1;
        var l = fx - half, t = fy - half, r = fx + half, b = fy + half;

        // --- 앞칸 점유 검사(칸 전체) ---
        var hit_wall = collision_rectangle(l, t, r, b, Obj_wall,       false, true);
        var b1       = collision_rectangle(l, t, r, b, Obj_box_parent,  false, true);
        var cat1     = collision_rectangle(l, t, r, b, Obj_cat_parent,  false, true);

        // 0) 벽이면 막힘
        if (hit_wall) {
            // 아무 것도 안 함
        }
       else if (b1 != noone)
{
    // === 2칸 박스 축 제한(오브젝트 이름으로 강제) ===
    // width(2x1)는 위/아래만 허용, length(1x2)는 좌/우만 허용
    var lock_axis = false;
    if (b1.object_index == Obj_width_box) {
        // 좌/우(긴 축)으로는 금지 → 위/아래만 허용
        if (dx32 != 0) lock_axis = true;
    }
    else if (b1.object_index == Obj_length_box) {
        // 위/아래(긴 축)으로는 금지 → 좌/우만 허용
        if (dy32 != 0) lock_axis = true;
    }

    if (lock_axis) {
        // 여길 통과하면 '아무 것도 하지 않음' = 밀기 실패
        // (중요: 아래 로직이 실행되지 않도록 여기서 블록을 끝내야 함)
    }
    else
    {
        // ====== (기존) 다칸 박스 대응 로직 ======
        // 1) b1 전면이 비어있는지
        var blocked = !box_edge_clear(b1, dx32, dy32);

        // 2) b2 탐색 : b1 전면 전체 한 칸 앞에서 추가 박스 찾기
        var b2 = noone;
        if (!blocked) {
            var g = self.grid;
            var w1 = (b1.size_w != undefined) ? b1.size_w : 1;
            var h1 = (b1.size_h != undefined) ? b1.size_h : 1;
            var left_c1 = floor(b1.bbox_left / g) * g + g*0.5;
            var top_c1  = floor(b1.bbox_top  / g) * g + g*0.5;
            var half = g * 0.5 - 1;

            if (dx32 != 0) {
                var lead_x1 = (dx32 > 0) ? left_c1 + (w1-1)*g : left_c1;
                for (var j=0; j<h1; j++) {
                    var cx = lead_x1 + dx32;
                    var cy = top_c1 + j*g;
                    var l2 = cx - half, t2 = cy - half, r2 = cx + half, b2r = cy + half;
                    var hit = collision_rectangle(l2,t2,r2,b2r, Obj_box_parent, false, true);
                    if (hit != noone && hit != b1) { b2 = hit; break; }
                }
            } else {
                var lead_y1 = (dy32 > 0) ? top_c1 + (h1-1)*g : top_c1;
                for (var i=0; i<w1; i++) {
                    var cx = left_c1 + i*g;
                    var cy = lead_y1 + dy32;
                    var l2 = cx - half, t2 = cy - half, r2 = cx + half, b2r = cy + half;
                    var hit = collision_rectangle(l2,t2,r2,b2r, Obj_box_parent, false, true);
                    if (hit != noone && hit != b1) { b2 = hit; break; }
                }
            }

            // b2가 있으면 b2 전면도 비어 있어야
            if (b2 != noone) {
                if (!box_edge_clear(b2, dx32, dy32)) blocked = true;
            }
        }

        // 3) 필요 파워(라이트=1, 헤비=2)
        var count_light = (b1.object_index == Obj_heavy_box) ? 0 : 1;
        var count_heavy = (b1.object_index == Obj_heavy_box) ? 1 : 0;
        if (b2 != noone) {
            count_light += (b2.object_index == Obj_heavy_box) ? 0 : 1;
            count_heavy += (b2.object_index == Obj_heavy_box) ? 1 : 0;
        }
        var required = count_light + count_heavy * 2;

        // 4) 푸셔 수(뒤 한 칸 보조 고양이: 정지 + 같은 방향)
        var g2 = self.grid;
        var half2 = g2 * 0.5 - 1;
        var hx = cell_x - dx32, hy = cell_y - dy32;
        var lh = hx - half2, th = hy - half2, rh = hx + half2, bh = hy + half2;
        var helper = collision_rectangle(lh, th, rh, bh, Obj_cat_parent, false, true);
        var pushers = 1;
        if (helper != noone && helper != id) {
            if (helper.dir == dir && !helper.moving) pushers += 1;
        }

        // 5) 최종 판정 & 예약(앞→뒤) → 보조 → 나
        if (!blocked && pushers >= required)
        {
            if (b2 != noone) { b2.queue_dx += dx32; b2.queue_dy += dy32; b2.moving = true; }
            { b1.queue_dx += dx32; b1.queue_dy += dy32; b1.moving = true; }

            if (pushers >= 2 && helper != noone && helper != id && helper.dir == dir && !helper.moving) {
                helper.queue_dx += dx32; helper.queue_dy += dy32; helper.moving = true;
                // (원하면 helper push 스프라도 전환)
            }

            queue_dx += dx32; queue_dy += dy32; moving = true;

            var my_push;
            switch (dir) {
                case "up":    my_push = Spr_white_cat_back_push;   break;
                case "down":  my_push = Spr_white_cat_front_push;  break;
                case "left":  my_push = Spr_white_cat_left_push;   break;
                case "right": my_push = Spr_white_cat_right_push;  break;
            }
            if (sprite_index != my_push) { sprite_index = my_push; image_index = 0; }
        }
    }
}


            else
            {
                // --- 2) 앞칸이 고양이? → '릴레이' (앞 고양이 앞칸이 비어 있으면 둘 다 1칸 이동)
                var front_cat = instance_position(fx, fy, Obj_cat_parent);
                if (front_cat != noone && front_cat != id)
                {
                    // 고양이는 서로 '막힘'이 기본. 단, 릴레이 조건 충족 시 같이 이동.
                    var fx2c = fx + dx32, fy2c = fy + dy32;

                    var relay_blocked = false;
                    if (instance_position(fx2c, fy2c, Obj_wall)        != noone) relay_blocked = true;
                    if (!relay_blocked && instance_position(fx2c, fy2c, Obj_box_parent) != noone) relay_blocked = true;
                    if (!relay_blocked && instance_position(fx2c, fy2c, Obj_cat_parent)  != noone) relay_blocked = true;

                    // 앞 고양이 조건: 같은 방향을 보고 있고 정지
                    if (!relay_blocked && front_cat.dir == dir && !front_cat.moving)
                    {
                        with (front_cat) { queue_dx += dx32; queue_dy += dy32; moving = true; }

                        // 나도 예약 + push 스프라
                        queue_dx += dx32; queue_dy += dy32; moving = true;
                        var my_push2;
                        switch (dir) {
                            case "up":    my_push2 = Spr_white_cat_back_push;   break;
                            case "down":  my_push2 = Spr_white_cat_front_push;  break;
                            case "left":  my_push2 = Spr_white_cat_left_push;   break;
                            case "right": my_push2 = Spr_white_cat_right_push;  break;
                        }
                        if (sprite_index != my_push2) { sprite_index = my_push2; image_index = 0; }
                    }
                }
                else
                {
                    // --- 3) 빈 칸 → 평소 이동 + 걷기 스프라
                    queue_dx += dx32; queue_dy += dy32; moving = true;
                    var walk_sprite;
                    switch (dir) {
                        case "up":    walk_sprite = Spr_white_cat_back_walking;   break;
                        case "down":  walk_sprite = Spr_white_cat_front_walking;  break;
                        case "left":  walk_sprite = Spr_white_cat_left_walking;   break;
                        case "right": walk_sprite = Spr_white_cat_right_walking;  break;
                    }
                    if (sprite_index != walk_sprite) { sprite_index = walk_sprite; image_index = 0; }
                }
            }
        }
    }

// 2) 예약분 만큼 보간 이동
if (moving)
{
    if (queue_dx != 0) {
        var sx = clamp(queue_dx, -move_speed, move_speed);
        x      += sx;
        queue_dx -= sx;
    }
    if (queue_dy != 0) {
        var sy = clamp(queue_dy, -move_speed, move_speed);
        y      += sy;
        queue_dy -= sy;
    }

    if (queue_dx == 0 && queue_dy == 0) {
        moving = false;
    }
}

// 3) 완전히 멈췄을 때만 STOP 스프라로 전환
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
    if (sprite_index != stop_sprite) { sprite_index = stop_sprite; image_index = 0; }
}
