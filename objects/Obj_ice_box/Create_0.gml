/// Obj_ice_box : Create
event_inherited();      // (부모) Obj_box_parent의 Create 실행
size_w = 1;             // 얼음은 1x1 가정 (원하면 바꿔도 동작함)
size_h = 1;

sliding  = false;       // 미끄러짐 진행 중?
slide_dx = 0;           // 최근 이동 방향(격자 단위)
slide_dy = 0;
