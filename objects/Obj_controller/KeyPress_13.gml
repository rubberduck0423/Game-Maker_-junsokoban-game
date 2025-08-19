/// Obj_controller : Key Press <Enter>
if (room == Room_0) {
    room_goto(Room);    // 타이틀 → 실제 시작 룸
} else if (room == Room_7) {
    room_goto(Room_0);  // 엔딩 → 타이틀
}
