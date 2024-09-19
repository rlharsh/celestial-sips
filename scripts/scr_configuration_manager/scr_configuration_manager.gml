function ConfigurationManager() constructor {
	var _appdata_path		= environment_get_variable("LOCALAPPDATA");
	game_folder				= _appdata_path + "\\Celestial Sips\\";
	configuration_file		= game_folder + "\\config.json";
	config_data				= -1;
	configuration_showing	= false;

	if (!directory_exists(game_folder)) {
		directory_create(game_folder);	
	}
	if (!file_exists(configuration_file)) {
		configuration_manger_write_default(configuration_file);
	}
	
	config_data = configuration_manager_load_configuration(configuration_file);
	
	config_ui				= new SimpleUI();
	config_page_gameplay	= new SimplePage("GAME_CONFIGURATION_GAMEPLAY");
	config_page_audio		= new SimplePage("GAME_CONFIGURATION_AUDIO");
	config_page_display		= new SimplePage("GAME_CONFIGURATION_DISPLAY");
	
	var _config_page_gameplay_group	= new SimpleGroup("CONFIG_GAMEPLAY", 0, 0,,,,true);
	_config_page_gameplay_group.add_control(new SimpleSprite(0, 0, spr_button_default, 0, _config_page_gameplay_group, {
		width: 200,
		height: 200,
	}));
	_config_page_gameplay_group.add_control(new SimpleText(0, 0, "[rainbow]Hello World!", _config_page_gameplay_group, false));
	
	config_page_gameplay.add_group(_config_page_gameplay_group);
	
	config_ui.add_page(config_page_gameplay);
	config_ui.add_page(config_page_audio);
	config_ui.add_page(config_page_display);
	
	config_ui.set_page("GAME_CONFIGURATION_GAMEPLAY");
	
	
	static draw = function() {
		if (!configuration_showing) return;
		
		config_ui.draw();
	}
}