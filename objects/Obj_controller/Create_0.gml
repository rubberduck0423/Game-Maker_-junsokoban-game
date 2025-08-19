/// Obj_controller : Create

// 0) 싱글톤 가드: 가장 먼저!
if (instance_number(Obj_controller) > 1) { instance_destroy(); exit; }

// 1) 플레이어 포인터는 아직 모름 → 좌표 접근 금지
global.current_player = noone;

// 2) BGM 초기화 및 재생
bgm_sound  = Sound_BGM_1;
bgm_handle = -1;

bgm_play = function (snd) {
    if (bgm_handle != -1) audio_sound_gain(bgm_handle, 0, 300); // 페이드아웃
    bgm_handle = audio_play_sound(snd, 0, true);                 // loop
    audio_sound_gain(bgm_handle, 1, 300);                        // 페이드인
};

bgm_play(bgm_sound);

// ❌ (삭제/이동) 여기서 current_player.x/y 쓰던 indicator 생성은 아래 Room Start로 이동
