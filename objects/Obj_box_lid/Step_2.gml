/// Obj_box_lid : End Step
if (!instance_exists(owner)) { instance_destroy(); exit; }

x             = owner.x;
y             = owner.y;
sprite_index  = owner.spr_lid;
image_index   = owner.image_index;
image_speed   = owner.image_speed;
image_xscale  = owner.image_xscale;
image_yscale  = owner.image_yscale;
image_angle   = owner.image_angle;
image_alpha   = owner.image_alpha;
