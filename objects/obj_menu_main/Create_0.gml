_main_menu = new SimpleUI();

var _main = new SimpleGroup("MAIN", 0, 0,,,,true);

_main.add_control(new SimpleButton(50, 30, _main, {
	text: "[c_black]New Game",
	width: 200
}));

_main.add_control(new SimpleButton(50, 42, _main, {
	text: "[c_black]Continue",
	width: 200
}));

_main.add_control(new SimpleButton(50, 54, _main, {
	text: "[c_black]Multiplayer",
	width: 200
}));

_main.add_control(new SimpleButton(50, 66, _main, {
	text: "[c_black]Load Game",
	width: 200
}));

_main.add_control(new SimpleButton(50, 78, _main, {
	text: "[c_black]Credits",
	width: 200
}));

_main.add_control(new SimpleButton(50, 90, _main, {
	text: "[c_black]Exit",
	width: 200
}));

var _main_page = new SimplePage("UI_MAIN");
_main_page.add_group(_main);

_main_menu.add_page(_main_page);
_main_menu.set_page("UI_MAIN");