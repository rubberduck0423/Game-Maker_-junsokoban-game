// 처음엔 검은 고양이를 조종
global.current_player = instance_find(Obj_black_cat, 0);

if (!instance_exists(Obj_where)) {
    indicator = instance_create_layer(global.current_player.x,
                                      global.current_player.y,
                                      "Instances",
                                      Obj_where);
}
