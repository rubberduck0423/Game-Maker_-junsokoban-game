event_inherited();


/// Obj_trigger_any : Create
tile = 32;
grid_w = 1;   // 32px
grid_h = 1;   // 32px
target_room = noone;
exit_lock   = false;
debug_draw  = false;

reset = function () {
    _reset_base();
    exit_lock = false;
    if (variable_instance_exists(id, "_count"))  _count  = 0;
    if (variable_instance_exists(id, "_cur_in")) _cur_in = false;
};
