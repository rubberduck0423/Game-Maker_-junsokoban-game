// 현재 플레이어를 토글
if (global.current_player.object_index == Obj_black_cat) {
    global.current_player = instance_find(Obj_white_cat, 0);
} else {
    global.current_player = instance_find(Obj_black_cat, 0);
}
