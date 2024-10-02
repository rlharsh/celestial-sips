depth = -9999;
global.configuration_showing	= false;

// Create the tab controller
configuration_manager	= new SimpleUITabs("Configuration", 200, 200);

// Create the UI Pages
var _general_page_group = new SimpleGroup("config_general_ui_group", 0, 0,200,200);
_general_page_group.add_control(new SimpleText(10, 40, "[c_black]Hello World!", _general_page_group,true,{
	alignment: UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT	
},true));

var _display_page_group = new SimpleGroup("config_display_ui_group", 0, 0, 200, 200);
_display_page_group.add_control(new SimpleText(10, 40, "[c_black]Hello Gangster!", _general_page_group,true,{
	alignment: UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT	
},true));

// Create the tabs
var _general_tab	= new SimpleUITab("config_general_ui", 0, _general_page_group);
var _display_tab	= new SimpleUITab("config_general_display", 2, _display_page_group);
var _audio_tab		= new SimpleUITab("config_general_audio", 4);
var _control_tab	= new SimpleUITab("config_general_control", 6);

// Add the tabs to the tab controller.
configuration_manager.add_tab(_general_tab);
configuration_manager.add_tab(_display_tab);
configuration_manager.add_tab(_audio_tab);
configuration_manager.add_tab(_control_tab);