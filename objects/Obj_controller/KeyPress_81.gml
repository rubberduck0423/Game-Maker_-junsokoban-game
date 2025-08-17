/// Obj_controller : Key Press <Q>
with (Obj_resettable_parent) {
    if (variable_instance_exists(id, "reset")) {
        reset();
    } else if (variable_instance_exists(id, "_reset_base")) {
        _reset_base(); // 최소 초기화(위치/이동큐)
    } else {
        // 디버깅용: 누가 빠졌는지 콘솔에 찍기
        show_debug_message("RESET MISSING -> " + object_get_name(object_index));
    }
}

// (선택) 조작자 복원
if (!variable_global_exists("current_player") || !instance_exists(global.current_player)) {
    if (instance_number(Obj_cat_parent) > 0) {
        global.current_player = instance_find(Obj_cat_parent, 0);
    }
}
