/// Obj_game : Create  (전역 벽 쿼리 함수 등록)
if (is_undefined(global.wall_rect_hit)) {
    global.wall_rect_hit = function(l, t, r, b) {
        var L = ds_list_create();
        var hit = noone;
        var n = collision_rectangle_list(l, t, r, b, Obj_wall, false, true, L, true);
        for (var i = 0; i < n; i++) {
            var w = L[| i];
            if (w.active) { hit = w; break; } // ★ active=true만 벽으로 취급
        }
        ds_list_destroy(L);
        return hit;
    };
}

if (is_undefined(global.wall_point_hit)) {
    global.wall_point_hit = function(px, py) {
        var L = ds_list_create();
        var hit = noone;
        var n = collision_point_list(px, py, Obj_wall, false, true, L, true);
        for (var i = 0; i < n; i++) {
            var w = L[| i];
            if (w.active) { hit = w; break; }
        }
        ds_list_destroy(L);
        return hit;
    };
}
