function Script1(scr_wall_query){
	
/// wall_rect_hit(l, t, r, b) -> 활성 벽(Obj_wall) or noone
function wall_rect_hit(l, t, r, b) {
    var list = ds_list_create();
    var hit  = noone;
    var n = collision_rectangle_list(l, t, r, b, Obj_wall, false, true, list, true);
    for (var i = 0; i < n; i++) {
        var w = list[| i];
        if (w.active) { hit = w; break; } // ★ active=true만 벽으로 인정
    }
    ds_list_destroy(list);
    return hit;
}

/// wall_point_hit(px, py) -> 활성 벽(Obj_wall) or noone
function wall_point_hit(px, py) {
    var list = ds_list_create();
    var hit  = noone;
    var n = collision_point_list(px, py, Obj_wall, false, true, list, true);
    for (var i = 0; i < n; i++) {
        var w = list[| i];
        if (w.active) { hit = w; break; }
    }
    ds_list_destroy(list);
    return hit;
}



}