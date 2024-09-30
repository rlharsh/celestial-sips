_main_menu = new SimpleUI();

var _main = new SimpleGroup("MAIN", 0, 0,,,,true);

_main.add_control(new SimpleSprite(50, 26, spr_testing, 0, _main));

_main.add_control(new SimpleButton(50, 50, _main, {
	text: "[c_white]Play Game",
	width: 220,
}));

_main.add_control(new SimpleButton(50, 60, _main, {
	text: "[c_white]Achievements",
	width: 220
}));

_main.add_control(new SimpleButton(50, 70, _main, {
	text: "[c_white]Settings",
	width: 220,
	callback: function() {
		configuration_manager_show_options();	
	}
}));


_main.add_control(new SimpleButton(50, 80, _main, {
	text: "[c_white]Credits",
	width: 220
}));

_main.add_control(new SimpleButton(50, 90, _main, {
	text: "[c_white]Exit",
	width: 200,
	callback: function() {
		game_end(0);	
	}
}));

_main.add_control(new SimpleIconButton(1, 99, _main, {
	icon: spr_icon_journal,
	mouseover: true,
	alignment: UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT,
}));

var _main_page = new SimplePage("UI_MAIN");
_main_page.add_group(_main);

_main_menu.add_page(_main_page);
_main_menu.set_page("UI_MAIN");