/// Obj_wall : Create
active = true;           // ← 충돌에 참여 여부

// (보기 편하라고만) 비활성일 때 안 보이게 하고 싶으면 사용
visible = true;

// 공개 API
wall_enable = function () {
    if (!active) {
        active  = true;
        visible = true; // 원하면 주석
    }
};
wall_disable = function () {
    if (active) {
        active  = false;
        visible = false; // 원하면 주석
    }
};

active = true;
wall_enable  = function(){ active = true;  visible = true; };
wall_disable = function(){ active = false; visible = false; };
