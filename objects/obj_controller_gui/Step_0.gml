/// @description Zoom GUI / Detectc Fullscreen Switch
var _full=window_get_fullscreen();
if(is_full_screen != _full)
{
	is_full_screen=_full;
	if(!is_full_screen)
	{
		set_aspect(ASPECT._16X9);
	} 
	if (_full) {
		get_primary_aspect_ratio();	
	}
}

if (keyboard_check(vk_tab)) {
	window_set_fullscreen(!window_get_fullscreen());	
}

