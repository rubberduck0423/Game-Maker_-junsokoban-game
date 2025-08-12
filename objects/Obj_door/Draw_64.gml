/// Obj_door : Draw GUI
if (debug_draw) {
    var _s = ["CLOSED","OPENING","OPEN_HOLD","CLOSING"][state];
    draw_set_alpha(0.8);
    draw_set_colour(c_black);
    draw_text(16, 16, "Door state: " + _s);
    draw_text(16, 32, "sprite: " + string(sprite_index) + "  frame: " + string(floor(image_index)));
    draw_set_alpha(1);
}
