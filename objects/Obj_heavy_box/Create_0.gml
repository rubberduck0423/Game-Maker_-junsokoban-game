event_inherited();   // 부모의 Create 초기화를 실행


/// Obj_heavy_box : Create
spr_lid = Spr_heavy_box_lid;

var _lid_layer = layer_get_id("Layer_Lid");
if (_lid_layer == -1) _lid_layer = layer;

lid_id = instance_create_layer(x, y, _lid_layer, Obj_box_lid);
lid_id.owner = id;
