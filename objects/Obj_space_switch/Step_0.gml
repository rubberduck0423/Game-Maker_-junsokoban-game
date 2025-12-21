/// Obj_enter_switch : Step
var hit = keyboard_check_pressed(vk_space);
if (!hit) exit;

if (room == Room_0) {
    // 타이틀 → 실제 시작 방
    room_goto(Room_x);      // ← 리소스 트리에서 'Room'으로 이동
}
else if (room == Room_x) {
    // 엔딩 → 타이틀
    room_goto(Room_0);
}
// 다른 방에서는 아무 일도 안 함
