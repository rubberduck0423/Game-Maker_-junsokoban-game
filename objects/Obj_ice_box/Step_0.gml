/// Obj_ice_box : Step

// A) 첫 푸시 감지 → 슬라이드 방향 기록
if (!sliding && (queue_dx != 0 || queue_dy != 0)) {
    slide_dx = sign(queue_dx);
    slide_dy = sign(queue_dy);
    sliding  = true;
}

// B) (부모) 한 칸씩 보간 이동 처리
event_inherited();  // Obj_box_parent의 Step: queue_*만큼 x/y 이동 + moving 갱신

// C) 한 칸 도착한 프레임에, 앞칸이 비어 있으면 다음 32를 자동 예약
if (sliding && !moving && queue_dx == 0 && queue_dy == 0)
{
    var g    = (self.grid != 0) ? self.grid : 32;
    var half = g * 0.5 - 1;

    // 박스가 점유 중인 '맨 왼쪽/맨 위' 셀 중심
    var left_c = floor(bbox_left / g) * g + g*0.5;
    var top_c  = floor(bbox_top  / g) * g + g*0.5;

    var w = (size_w != undefined) ? size_w : 1;
    var h = (size_h != undefined) ? size_h : 1;

    var can_continue = true;

    if (slide_dx != 0) {
        // 가로 진행: 전면(h줄) 한 칸 앞 전체가 비어야 함
        var lead_x = (slide_dx > 0) ? left_c + (w-1)*g : left_c;
        for (var j = 0; j < h; j++) {
            var cx = lead_x + slide_dx * g;
            var cy = top_c + j * g;
            var l = cx - half, t = cy - half, r = cx + half, b = cy + half;
            if (collision_rectangle(l,t,r,b, Obj_wall,       false, true) ||
                collision_rectangle(l,t,r,b, Obj_box_parent, false, true) ||
                collision_rectangle(l,t,r,b, Obj_cat_parent, false, true))
            { can_continue = false; break; }
        }
        if (can_continue) {
            queue_dx += slide_dx * g;
            moving    = true;
        } else {
            sliding   = false;  // 장애물 만나면 종료
        }
    }
    else if (slide_dy != 0) {
        // 세로 진행: 전면(w줄) 한 칸 앞 전체가 비어야 함
        var lead_y = (slide_dy > 0) ? top_c + (h-1)*g : top_c;
        for (var i = 0; i < w; i++) {
            var cx = left_c + i * g;
            var cy = lead_y + slide_dy * g;
            var l = cx - half, t = cy - half, r = cx + half, b = cy + half;
            if (collision_rectangle(l,t,r,b, Obj_wall,       false, true) ||
                collision_rectangle(l,t,r,b, Obj_box_parent, false, true) ||
                collision_rectangle(l,t,r,b, Obj_cat_parent, false, true))
            { can_continue = false; break; }
        }
        if (can_continue) {
            queue_dy += slide_dy * g;
            moving    = true;
        } else {
            sliding   = false;
        }
    }
}
