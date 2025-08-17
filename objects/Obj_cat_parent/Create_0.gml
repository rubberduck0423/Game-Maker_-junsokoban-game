/// Obj_cat_parent : Create
event_inherited();                     // 부모(Obj_resettable_parent) 초기화 먼저

if (!variable_instance_exists(id, "dir"))
    dir = "down";                      // 기본 방향(원하는 값으로 바꿔도 됨)

if (is_undefined(_init))               // 안전 가드(혹시 부모가 안 돌았을 때)
    _init = { x: x, y: y };

_init.dir = dir;                       // 이제 안전하게 저장

reset = function () {
    _reset_base();  // x,y / 큐 초기화

    // 방향을 초기값으로 복원
    if (!is_undefined(_init.dir)) dir = _init.dir;

    // 방향별 '정지' 스프라 강제 (검/흰 분기)
    var stop_sprite;
    if (object_index == Obj_black_cat) {
        switch (dir) {
            case "up":    stop_sprite = Spr_black_cat_back_stop;   break;
            case "down":  stop_sprite = Spr_black_cat_front_stop;  break;
            case "left":  stop_sprite = Spr_black_cat_left_stop;   break;
            case "right": stop_sprite = Spr_black_cat_right_stop;  break;
        }
    } else {
        switch (dir) {
            case "up":    stop_sprite = Spr_white_cat_back_stop;   break;
            case "down":  stop_sprite = Spr_white_cat_front_stop;  break;
            case "left":  stop_sprite = Spr_white_cat_left_stop;   break;
            case "right": stop_sprite = Spr_white_cat_right_stop;  break;
        }
    }
    if (sprite_index != stop_sprite) { sprite_index = stop_sprite; image_index = 0; image_speed = 0; }
};
