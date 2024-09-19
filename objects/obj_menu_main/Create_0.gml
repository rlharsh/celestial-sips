_main_menu = new SimpleUI();

var _main = new SimpleGroup("MAIN", 0, 0,,,,true);

_main.add_control(new SimpleButton(50, 40, _main, {
	text: "[c_black]New Game",
	width: 200
}));

var _main_page = new SimplePage("UI_MAIN");
_main_page.add_group(_main);

_main_menu.add_page(_main_page);
_main_menu.set_page("UI_MAIN");