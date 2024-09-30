depth = -9999;
global.configuration_showing	= false;

// Create the tab controller
configuration_manager	= new SimpleUITabs("Configuration", 0, display_get_height() / 2, 300, 200);

// Create the tabs
var _general_tab	= new SimpleUITab("Gameplay");
var _display_tab	= new SimpleUITab("Display");
var _audio_tab		= new SimpleUITab("Audio");
var _control_tab	= new SimpleUITab("Controls");

// Create the user interface.
var _configuration_interface = new SimpleUI();

// Add the UI controller to the tab.
configuration_manager.set_ui_manager(_configuration_interface);

// Create the pages for the tabs.
var _configuration_interface_gamplay_page	= new SimplePage("config_general_ui");
var _configuration_interface_display_page	= new SimplePage("config_general_display");
var _configuration_interface_audio_page		= new SimplePage("config_general_audio");
var _configuration_interface_control_page	= new SimplePage("config_general_control");

// Add the tabs to the tab controller.
configuration_manager.add_tab(_general_tab);
configuration_manager.add_tab(_display_tab);
configuration_manager.add_tab(_audio_tab);
configuration_manager.add_tab(_control_tab);

// Add the pages to the UI controller
_configuration_interface.add_page(_configuration_interface_gamplay_page);
_configuration_interface.add_page(_configuration_interface_display_page);
_configuration_interface.add_page(_configuration_interface_audio_page);
_configuration_interface.add_page(_configuration_interface_control_page);

// Create the group for the Gameplay tab.
var _configuration_interface_gameplay = new SimpleGroup("general_ui", 10, 10);
_configuration_interface_gameplay.add_control(new SimpleText(0, 0, "Hello World", _configuration_interface_gameplay));

// Create the group for the Display tab.
var _configuration_interface_display = new SimpleGroup("display_ui", 10, 10);
_configuration_interface_display.add_control(new SimpleText(0, 0, "", _configuration_interface_display));

// Create the group for the Audio tab.
var _configuration_interface_audio = new SimpleGroup("audio_ui", 10, 10);

// Create the group for the Control tab.
var _configuration_interface_control = new SimpleGroup("control_ui", 10, 10);

// Add the group to the page.
_configuration_interface_gamplay_page.add_group(_configuration_interface_gameplay);
_configuration_interface_display_page.add_group(_configuration_interface_display);

// Set the active page
_configuration_interface.set_page("config_general_ui");