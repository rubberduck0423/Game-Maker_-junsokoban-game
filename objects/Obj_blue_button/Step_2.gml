/// Obj_blue_button : End Step
var touching =
    place_meeting(x, y, Obj_cat_parent) ||
    place_meeting(x, y, Obj_box_parent);

if (touching) _press_timer = press_grace; else if (_press_timer > 0) _press_timer--;
pressed = (_press_timer > 0);

var want = pressed ? spr_down : spr_up;
if (sprite_index != want) { sprite_index = want; image_index = 0; image_speed = 0; }
