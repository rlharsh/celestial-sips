display_set_gui_size(480, 270);
font_add_sprite_ext(spr_carton, " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 1, 2);
scribble_font_set_default("spr_carton");

ui_container = new SimpleUI();

var _hud_display = new SimpleGroup("HUD", 0, 0, display_get_gui_width(), display_get_gui_height(), false, true);

ui_container.add_group(_hud_display);

_hud_display.add_control(new SimpleButton(40, 0, _hud_display, {
	text: "[c_black]New Game",
	width: 200,
	alignment: UI_DISPLAY_ALIGNMENT.TOP_LEFT,
	callback: function() {
		// game_end(0);
	}
}, true));


_hud_display.add_control(new SimpleIconButton(0, 0, _hud_display, {
	icon: spr_icon_config,
	mouseover: true,
	alignment: UI_DISPLAY_ALIGNMENT.TOP_LEFT,
	point_control: true,
}));

_hud_display.add_control(new SimpleText(50, 50, "[wave][rainbow]Hello world!", _hud_display, true, {
	alignment: UI_DISPLAY_ALIGNMENT.TOP_LEFT,
}));

_hud_display.add_control(new SimpleCheckbox(200, 50, false, _hud_display, , true));

_hud_display.add_control(new SimpleSprite(50, 50, spr_icon_apple, 0, _hud_display, {
	alignment: UI_DISPLAY_ALIGNMENT.TOP_LEFT,	
}));

var _demo_display_button_group = new SimpleGroup("DEMO", 0, 0);

ui_container.add_group(_demo_display_button_group);

_demo_display_button_group.add_control(new SimpleButton(50, 50, _hud_display, {
	text: "[c_black]View Main UI",
	width: 200,
	callback: function() {
		other.ui_container.set_page("UI_MAIN");
	}
}));


var _main_hud = new SimplePage("UI_MAIN");
_main_hud.add_group(_hud_display);

var _demo_hud = new SimplePage("DEMO");
_demo_hud.add_group(_demo_display_button_group);

ui_container.add_page(_main_hud);
ui_container.add_page(_demo_hud);
ui_container.set_page("DEMO");