if (variable_global_exists("current_player") && instance_exists(global.current_player))
{
    var p = global.current_player;
    
    x = p.x;
    // y축은 아래로 증가하므로 “머리 위”는 y를 **마이너스 방향**으로
    y = p.y - (p.sprite_height / 2) - 4;   // 4px 여유 간격
    
    // 필요하면 방향에 따라 인디케이터 뒤집기·색상 변경 등도 여기서
}