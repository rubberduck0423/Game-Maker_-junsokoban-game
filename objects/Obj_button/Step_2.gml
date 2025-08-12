/// Obj_button : End Step
// 고양이/박스 접촉 여부 판정
var touching =
    place_meeting(x, y, Obj_cat_parent) ||
    place_meeting(x, y, Obj_box_parent);

// 바운스 방지: 접촉이 끊겨도 press_grace 프레임 만큼 유지
if (touching) {
    _press_timer = press_grace;
} else if (_press_timer > 0) {
    _press_timer -= 1;
}

pressed = (_press_timer > 0);

// 스프라이트 전환
if (pressed) {
    if (sprite_index != Spr_button_down) {
        sprite_index = Spr_button_down;
        image_index = 0;
        image_speed = 0;
    }
} else {
    if (sprite_index != Spr_button_up) {
        sprite_index = Spr_button_up;
        image_index = 0;
        image_speed = 0;
    }
}
