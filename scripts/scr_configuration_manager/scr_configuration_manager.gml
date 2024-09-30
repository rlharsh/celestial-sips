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
	config_page_gui			= new SimplePage("GAME_CONFIGURATION_GUI", true);
	config_page_gameplay	= new SimplePage("GAME_CONFIGURATION_GAMEPLAY");
	config_page_audio		= new SimplePage("GAME_CONFIGURATION_AUDIO");
	config_page_display		= new SimplePage("GAME_CONFIGURATION_DISPLAY");
	
	var _config_page_gameplay_settings_group = new SimpleGroup("CONFG_GAMEPLAY", 0, 0, 400, 200,,,{
		center_x: true,
		center_y: true,
	});
	_config_page_gameplay_settings_group.add_control(new SimpleText(0,0, "Testing", _config_page_gameplay_settings_group));
	
	config_page_gameplay.add_group(_config_page_gameplay_settings_group);
	
	var _config_page_gameplay_group	= new SimpleGroup("CONFIG_GUI", 50, 50, 400,,true,, {
		center_x: true,
		center_y: true,
	});
	
	_config_page_gameplay_group.add_control(new SimpleSprite(50, 50, spr_button_default, 0, _config_page_gameplay_group, {
		width:  160,
		height: 200,
	}));
	_config_page_gameplay_group.add_control(new SimpleIconButton(138, 52, _config_page_gameplay_group, {
		icon: spr_icon_gameplay
	}, true));
	_config_page_gameplay_group.add_control(new SimpleIconButton(162, 52, _config_page_gameplay_group, {
		icon: spr_icon_display
	}, true));
	_config_page_gameplay_group.add_control(new SimpleIconButton(186, 52, _config_page_gameplay_group, {
		icon: spr_icon_audio
	}, true));
	_config_page_gameplay_group.add_control(new SimpleIconButton(210, 52, _config_page_gameplay_group, {
		icon: spr_icon_controls
	}, true));
	
	_config_page_gameplay_group.add_control(new SimpleButton(50, 80, _config_page_gameplay_group,{
		text: "Back",	
		width: 200,
		callback: function() {
			configuration_manager_hide_options();
		}
	}, false));
	
	config_page_gui.add_group(_config_page_gameplay_group);
	
	config_ui.add_page(config_page_gui);
	config_ui.add_page(config_page_gameplay);
	config_ui.add_page(config_page_audio);
	config_ui.add_page(config_page_display);
	
	config_ui.set_page("GAME_CONFIGURATION_GAMEPLAY");
	
	
	static draw = function() {
		live_name = "config:draw";
		if (live_call()) return live_result;
		
		if (!configuration_showing) return;
		
		/*
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
		draw_set_color(c_white);
		draw_set_alpha(1);
		*/
		
		config_ui.draw();
	}
	
	static step = function() {
		if (input_check_pressed("cancel")) {
			configuration_manager_hide_options();	
		}
		config_ui.step();	
	}
}