/// Obj_resettable_parent : Create
// 1) 방 최초 상태 저장(공통: 위치만)
_init = { x: x, y: y };

// 2) 공통 초기화 베이스: 위치/이동만 다룸 (dir/state 등은 자식이 처리)
_reset_base = function () {
    x = _init.x;
    y = _init.y;

    if (variable_instance_exists(id, "moving")) {
        moving   = false;
        queue_dx = 0;
        queue_dy = 0;
    }
};

// 3) 기본 reset (자식에서 필요 시 덮어쓰기)
reset = function () {
    _reset_base();
};
