/// Obj_width_box : Room Start
if (!variable_instance_exists(id, "spr_lid") || spr_lid == -1) spr_lid = Spr_width_box_lid;

if (!variable_instance_exists(id, "lid_id") || !instance_exists(lid_id)) {
    var _lid_layer = layer_exists("Layer_Lid") ? layer_get_id("Layer_Lid") : layer;
    var _lid = instance_create_layer(x, y, _lid_layer, Obj_box_lid);
    _lid.owner = id;
    lid_id = _lid;
}
