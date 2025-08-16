event_inherited();   // 부모의 Create 초기화를 실행


/// Obj_basic_box : Create  // 본체
spr_lid = Spr_basic_box_lid;  // ← 네가 만든 lid 스프라 이름

var _lid_layer = layer_get_id("Layer_Lid");
if (_lid_layer == -1) _lid_layer = layer;

lid_id = instance_create_layer(x, y, _lid_layer, Obj_box_lid);
lid_id.owner = id;
