function ConfigurationManager() constructor {
	var _appdata_path	= environment_get_variable("LOCALAPPDATA");
	game_folder			= _appdata_path + "\\Celestial Sips\\";
	configuration_file	= game_folder + "\\config.json";
	config_data			= -1;

	if (!directory_exists(game_folder)) {
		directory_create(game_folder);	
	}
	if (!file_exists(configuration_file)) {
		configuration_manger_write_default(configuration_file);
	}
	
	config_data = configuration_manager_load_configuration(configuration_file);
}