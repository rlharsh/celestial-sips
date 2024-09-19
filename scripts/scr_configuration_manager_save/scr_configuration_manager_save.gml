function configuration_manager_save(){
	var _appdata_path	= environment_get_variable("LOCALAPPDATA");
	game_folder			= _appdata_path + "\\Celestial Sips\\";
	configuration_file	= game_folder + "\\config.json";
	
	try {
		var _config_file	= file_text_open_write(configuration_file);
		file_text_write_string(_config_file, json_stringify(obj_controller_configuration.configuration_manager.config_data, true));
		file_text_close(_config_file);
	} catch (_e) {
		show_debug_message(_e);
	}
}