event_inherited();


tile = 32;
grid_w = 1;
grid_h = 1;          // ← 32×32 (중요)
mode_group = true;   // ← 그룹 모드 ON (중요)
channel_id = 1;      // ← 두 인스턴스 모두 같은 숫자 (중요)

target_room = noone// 두 인스턴스 모두 같은 다음 룸으로
exit_lock   = false;
debug_draw  = false;

// 경고(노란줄) 방지용 인스턴스 변수 초기화
_group_all_ok     = false;
_group_cur_in_any = false;


reset = function () {
    _reset_base();
    exit_lock = false;
    if (variable_instance_exists(id, "_count"))  _count  = 0;
    if (variable_instance_exists(id, "_cur_in")) _cur_in = false;
};
