/// Obj_box_parent : Create
event_inherited();  // 부모 저장 세팅


grid       = 32;
move_speed = 4;

queue_dx = 0;
queue_dy = 0;
moving   = false;

// 기본값(1×1). 가로/세로 박스는 자식에서 덮어써.
size_w = 1;
size_h = 1;

/// Obj_box_parent : reset 오버라이드
reset = function () {
    _reset_base(); // x,y 복원 + moving/queue 0

    // 특수 런타임 값들 초기화(있을 때만)
    if (variable_instance_exists(id, "sliding")) sliding = false;
    if (variable_instance_exists(id, "vel_x"))   vel_x   = 0;
    if (variable_instance_exists(id, "vel_y"))   vel_y   = 0;
    if (variable_instance_exists(id, "timer"))   timer   = 0;
};
