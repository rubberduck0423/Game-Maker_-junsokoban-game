// 처음엔 검은 고양이를 조종
global.current_player = instance_find(Obj_black_cat, 0);

if (!instance_exists(Obj_where)) {
    indicator = instance_create_layer(global.current_player.x,
                                      global.current_player.y,
                                      "Instances",
                                      Obj_where);
}


/// Obj_controller : Create
bgm_sound  = Sound_BGM_1; // 너가 가져온 곡
bgm_handle = -1;

// 간단 재생 함수(페이드인/아웃 포함)
bgm_play = function (snd) {
    if (bgm_handle != -1) audio_sound_gain(bgm_handle, 0, 300); // 0.3초 페이드아웃
    bgm_handle = audio_play_sound(snd, 0, true);                 // loop = true
    audio_sound_gain(bgm_handle, 1, 300);                        // 페이드인
};

// 게임 시작 시 바로 재생
bgm_play(bgm_sound);
