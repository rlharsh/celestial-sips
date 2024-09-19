function configuration_manger_write_default(_file){
	try {
		game_options = {
			gameplay: {
				gamepad_rumble: true,
				twenty_four_hour_clock: false,
				pause_on_unfocus: true,
			},
			display: {
				display_mode: 0,
				vsync: true,
				resolution: 0,
				game_scale: 0,
			},
			audio: {
				global_volume: 100,
				sfx_volume: 100,
				music_volume: 100,
				amibent_volume: 100,
				pause_audio_unfocus: true,
			},
			controls: {
				
			},
		};
		var _config_file	= file_text_open_write(_file);
		file_text_write_string(_config_file, json_stringify(game_options, true));
		file_text_close(_config_file);
	} catch (_e) {
		show_debug_message("Error saving file: " + _e);
	}
}