var cam = view_camera[0];
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);

var dw = display_get_width();
var dh = display_get_height();

// 화면에 맞는 최대 정수배
var scale = floor(min(dw / vw, dh / vh));
if (scale < 1) scale = 1;

window_set_fullscreen(false); // 창 모드에서 크기 맞춘 뒤
window_set_size(vw * scale, vh * scale);

// 픽셀 아트라면
texture_set_interpolation(false);
display_set_gui_size(vw, vh);
