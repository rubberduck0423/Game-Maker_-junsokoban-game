// 선택 안 됐으면 종료. 단, 이미 moving 중이면 계속 움직이게 허용
if (!variable_global_exists("current_player")) exit;
if (id != global.current_player && !moving) exit;

var g = self.grid;    // ← Step 전역에서 쓸 로컬 별칭

/// 앞면 전체(가로/세로 n칸) 한 칸 앞이 비었는지 검사 (아이스 박스 성공 시점 그대로)
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
            if (collision_rectangle(l,t,r,b, Obj_wall,       false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_box_parent, false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_cat_parent, false, true)) return false;
        }
    } else {
        var lead_y = (_dy32 > 0) ? top_c + (h-1)*grid : top_c;
        for (var i = 0; i < w; i++) {
            var cx = left_c + i*grid;
            var cy = lead_y + _dy32;
            var l = cx - half, t = cy - half, r = cx + half, b = cy + half;
            if (collision_rectangle(l,t,r,b, Obj_wall,       false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_box_parent, false, true)) return false;
            if (collision_rectangle(l,t,r,b, Obj_cat_parent, false, true)) return false;
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
        var b1       = collision_rectangle(l, t, r, b, Obj_box_parent, false, true);
        var cat1     = collision_rectangle(l, t, r, b, Obj_cat_parent, false, true);
		
		var front_cat = noone;

        // 0) 벽이면 막힘
        if (hit_wall) {
            // do nothing
        }
        // 1) 박스 밀기 (단독 시도)
        else if (b1 != noone)
        {
            // 축 제한: width(2x1)=위/아래만, length(1x2)=좌/우만
            var lock_axis = false;
            if (b1.object_index == Obj_width_box  && dx32 != 0) lock_axis = true; // 가로형은 좌/우 금지
            if (b1.object_index == Obj_length_box && dy32 != 0) lock_axis = true; // 세로형은 위/아래 금지

            if (!lock_axis)
            {
                // b1 전면 비었나
                var blocked = !box_edge_clear(b1, dx32, dy32);

                // b2 탐색 : b1 전면 전체 한 칸 앞에서 추가 박스 찾기
                var b2 = noone;
                if (!blocked) {
                    var w1 = (b1.size_w != undefined) ? b1.size_w : 1;
                    var h1 = (b1.size_h != undefined) ? b1.size_h : 1;
                    var left_c1 = floor(b1.bbox_left / g) * g + g * 0.5;
                    var top_c1  = floor(b1.bbox_top  / g) * g + g * 0.5;
                    var half2 = g * 0.5 - 1;

                    if (dx32 != 0) {
                        var lead_x1 = (dx32 > 0) ? left_c1 + (w1-1)*g : left_c1;
                        for (var j=0; j<h1; j++) {
                            var cx = lead_x1 + dx32;
                            var cy = top_c1 + j*g;
                            var l2 = cx - half2, t2 = cy - half2, r2 = cx + half2, b2r = cy + half2;
                            var hit = collision_rectangle(l2,t2,r2,b2r, Obj_box_parent, false, true);
                            if (hit != noone && hit != b1) { b2 = hit; break; }
                        }
                    } else {
                        var lead_y1 = (dy32 > 0) ? top_c1 + (h1-1)*g : top_c1;
                        for (var i=0; i<w1; i++) {
                            var cx = left_c1 + i*g;
                            var cy = lead_y1 + dy32;
                            var l2 = cx - half2, t2 = cy - half2, r2 = cx + half2, b2r = cy + half2;
                            var hit = collision_rectangle(l2,t2,r2,b2r, Obj_box_parent, false, true);
                            if (hit != noone && hit != b1) { b2 = hit; break; }
                        }
                    }

                    if (b2 != noone) {
                        if (!box_edge_clear(b2, dx32, dy32)) blocked = true;
                        // b2가 2칸이면 조건 강화는 아래에서 required로 처리
						if (b2.object_index == Obj_width_box  && dx32 != 0) blocked = true; // width는 상하만
						if (b2.object_index == Obj_length_box && dy32 != 0) blocked = true; // length는 좌우만
                    }
                }

                // 필요 파워(라이트=1, 헤비=2)
                var count_light = (b1.object_index == Obj_heavy_box) ? 0 : 1;
                var count_heavy = (b1.object_index == Obj_heavy_box) ? 1 : 0;
                if (b2 != noone) {
                    count_light += (b2.object_index == Obj_heavy_box) ? 0 : 1;
                    count_heavy += (b2.object_index == Obj_heavy_box) ? 1 : 0;
                }
                var required = count_light + count_heavy * 2;

                // ★ 2칸 상자는 항상 최소 2명 필요
                if (b1.size_w > 1 || b1.size_h > 1) required = max(required, 2);
                if (b2 != noone && (b2.size_w > 1 || b2.size_h > 1)) required = max(required, 2);

                // 보조(뒤 한 칸 고양이)
                var hx = cell_x - dx32, hy = cell_y - dy32;
                var lh = hx - half, th = hy - half, rh = hx + half, bh = hy + half;
                var helper = collision_rectangle(lh, th, rh, bh, Obj_cat_parent, false, true);
                var pushers = 1;
                if (helper != noone && helper != id) {
                    if (helper.dir == dir && !helper.moving) pushers += 1;
                }

                if (!blocked && pushers >= required)
                {
                    if (b2 != noone) { b2.queue_dx += dx32; b2.queue_dy += dy32; b2.moving = true; }
                    { b1.queue_dx += dx32; b1.queue_dy += dy32; b1.moving = true; }

                    if (pushers >= 2 && helper != noone && helper != id && helper.dir == dir && !helper.moving) {
                        helper.queue_dx += dx32; helper.queue_dy += dy32; helper.moving = true;
                    }

                    queue_dx += dx32; queue_dy += dy32; moving = true;

                    var my_push;
                    switch (dir) {
                        case "up":    my_push = Spr_black_cat_back_push;   break;
                        case "down":  my_push = Spr_black_cat_front_push;  break;
                        case "left":  my_push = Spr_black_cat_left_push;   break;
                        case "right": my_push = Spr_black_cat_right_push;  break;
                    }
                    if (sprite_index != my_push) { sprite_index = my_push; image_index = 0; }
                }
            }
        }
        // 2) 앞칸이 고양이? → 조건 충족시에만 '협동 릴레이'
        else if (
            cat1 != noone && cat1 != id
            && cat1.dir == dir && !cat1.moving
            && instance_position(fx + dx32, fy + dy32, Obj_wall)       == noone
            && instance_position(fx + dx32, fy + dy32, Obj_cat_parent) == noone
        )
        {
            front_cat = cat1;

            // 앞 고양이 앞칸 박스?
            var b1c = instance_position(fx + dx32, fy + dy32, Obj_box_parent);

            if (b1c != noone)
            {
                // 축 제한
                var lock_axis2 = false;
                if (b1c.object_index == Obj_width_box  && dx32 != 0) lock_axis2 = true;
                if (b1c.object_index == Obj_length_box && dy32 != 0) lock_axis2 = true;

                if (!lock_axis2)
                {
                    var blocked2 = !box_edge_clear(b1c, dx32, dy32);

                    // b2c 탐색
                    var b2c = noone;
                    if (!blocked2)
{
    var w1c = (b1c.size_w != undefined) ? b1c.size_w : 1;
    var h1c = (b1c.size_h != undefined) ? b1c.size_h : 1;
    var left_c1c = floor(b1c.bbox_left / g) * g + g * 0.5;
    var top_c1c  = floor(b1c.bbox_top  / g) * g + g * 0.5;
    var half3 = g * 0.5 - 1;

    if (dx32 != 0) {
        var lead_x1c = (dx32 > 0) ? left_c1c + (w1c-1)*g : left_c1c;
        for (var j2=0; j2<h1c; j2++) {
            var cx2 = lead_x1c + dx32, cy2 = top_c1c + j2*g;
            var l3 = cx2 - half3, t3 = cy2 - half3, r3 = cx2 + half3, b3 = cy2 + half3;
            var hit2 = collision_rectangle(l3,t3,r3,b3, Obj_box_parent, false, true);
            if (hit2 != noone && hit2 != b1c) { b2c = hit2; break; }
        }
    } else {
        var lead_y1c = (dy32 > 0) ? top_c1c + (h1c-1)*g : top_c1c;
        for (var i2=0; i2<w1c; i2++) {
            var cx2 = left_c1c + i2*g, cy2 = lead_y1c + dy32;
            var l3 = cx2 - half3, t3 = cy2 - half3, r3 = cx2 + half3, b3 = cy2 + half3;
            var hit2 = collision_rectangle(l3,t3,r3,b3, Obj_box_parent, false, true);
            if (hit2 != noone && hit2 != b1c) { b2c = hit2; break; }
        }
    }

    if (b2c != noone) {
        // ★ b2c 축 제한: width는 상/하만, length는 좌/우만
        if (b2c.object_index == Obj_width_box  && dx32 != 0)  blocked2 = true;
        if (b2c.object_index == Obj_length_box && dy32 != 0)  blocked2 = true;

        // ★ 전면 비어있는지 최종 확인
        if (!blocked2 && !box_edge_clear(b2c, dx32, dy32))    blocked2 = true;
    }
}


                    // 두 고양이 파워 = 2 (heavy는 2)
                    var required2 = ((b1c.object_index == Obj_heavy_box) ? 2 : 1)
                                  + ((b2c != noone && b2c.object_index == Obj_heavy_box) ? 2
                                     : (b2c != noone ? 1 : 0));

                    // ★ 2칸 상자는 항상 최소 2명 필요
                    if (b1c.size_w > 1 || b1c.size_h > 1) required2 = max(required2, 2);
                    if (b2c != noone && (b2c.size_w > 1 || b2c.size_h > 1)) required2 = max(required2, 2);

                    var pushers2 = 2;

                    if (!blocked2 && pushers2 >= required2)
                    {
                        if (b2c != noone) { b2c.queue_dx += dx32; b2c.queue_dy += dy32; b2c.moving = true; }
                        { b1c.queue_dx += dx32; b1c.queue_dy += dy32; b1c.moving = true; }

                        front_cat.queue_dx += dx32;
                        front_cat.queue_dy += dy32;
                        front_cat.moving    = true;

                        queue_dx += dx32; queue_dy += dy32; moving = true;
						
						// 앞고양이 push 스프라 설정
    {
        var ps_front;
        if (front_cat.object_index == Obj_black_cat) {
            switch (dir) {
                case "up":    ps_front = Spr_black_cat_back_push;   break;
                case "down":  ps_front = Spr_black_cat_front_push;  break;
                case "left":  ps_front = Spr_black_cat_left_push;   break;
                case "right": ps_front = Spr_black_cat_right_push;  break;
            }
        } else {
            switch (dir) {
                case "up":    ps_front = Spr_white_cat_back_push;   break;
                case "down":  ps_front = Spr_white_cat_front_push;  break;
                case "left":  ps_front = Spr_white_cat_left_push;   break;
                case "right": ps_front = Spr_white_cat_right_push;  break;
            }
        }
        if (front_cat.sprite_index != ps_front) {
            front_cat.sprite_index = ps_front;
            front_cat.image_index  = 0;
        }
    }

    // 내 push 스프라 설정
    {
        var ps_me;
        if (object_index == Obj_black_cat) {
            switch (dir) {
                case "up":    ps_me = Spr_black_cat_back_push;   break;
                case "down":  ps_me = Spr_black_cat_front_push;  break;
                case "left":  ps_me = Spr_black_cat_left_push;   break;
                case "right": ps_me = Spr_black_cat_right_push;  break;
            }
        } else {
            switch (dir) {
                case "up":    ps_me = Spr_white_cat_back_push;   break;
                case "down":  ps_me = Spr_white_cat_front_push;  break;
                case "left":  ps_me = Spr_white_cat_left_push;   break;
                case "right": ps_me = Spr_white_cat_right_push;  break;
            }
        }
        if (sprite_index != ps_me) {
            sprite_index = ps_me;
            image_index  = 0;
        }
    }
    // ★★★ 추가 끝 ★★★
}
                    }
                }
				 else
            {
                // 박스가 없으면 둘 다 1칸 전진(순수 릴레이)
                front_cat.queue_dx += dx32;
                front_cat.queue_dy += dy32;
                front_cat.moving    = true;

                queue_dx += dx32; queue_dy += dy32; moving = true;
            }
            }
			// 3) 빈 칸 → 평소 이동
        else
        {
            queue_dx += dx32; queue_dy += dy32; moving = true;

            var walk_sprite;
            switch (dir) {
                case "up":    walk_sprite = Spr_black_cat_back_walking;   break;
                case "down":  walk_sprite = Spr_black_cat_front_walking;  break;
                case "left":  walk_sprite = Spr_black_cat_left_walking;   break;
                case "right": walk_sprite = Spr_black_cat_right_walking;  break;
            }
            if (sprite_index != walk_sprite) { sprite_index = walk_sprite; image_index = 0; }
        
    }
           
        }
         // (dx32||dy32)
} // (!moving && q==0)


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
        case "up":    stop_sprite = Spr_black_cat_back_stop;   break;
        case "down":  stop_sprite = Spr_black_cat_front_stop;  break;
        case "left":  stop_sprite = Spr_black_cat_left_stop;   break;
        case "right": stop_sprite = Spr_black_cat_right_stop;  break;
    }
    if (sprite_index != stop_sprite) { sprite_index = stop_sprite; image_index = 0; }
}
