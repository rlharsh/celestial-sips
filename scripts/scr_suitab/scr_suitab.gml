function SimpleUITabs(_title, _width, _height) constructor {
	title			= _title;
	xx				= display_get_gui_width() / 2;
	yy				= display_get_gui_height() / 2;
	width			= _width;
	height			= _height;
	tabs			= [];
	selected_tab	= 0;
	ui_manager		= new SimpleUI();
	
	static add_tab = function(_tab) {
		var _page = new SimplePage(_tab.title);
		ui_manager.add_page(_page);
		_tab.group.xx = xx - width / 2;
		_tab.group.yy = yy - height / 2;
		_tab.backdrop = true;
		//_tab.group.adaptive_width = false;
		_page.add_group(_tab.group);
		array_push(tabs, _tab);
		
		if (array_length(tabs) >= 0) {
			ui_manager.set_page(tabs[0].title);
		}	
	}
	
	static set_tab = function(_tab_name) {
		if (array_length(tabs) < 0) return;
		
		ui_manager.set_page(_tab_name);
	}
	
	static step = function() {
		live_name = "simple_ui_tabs:step";
		if (live_call()) return live_result;
		
		xx				= display_get_gui_width() / 2;
		yy				= display_get_gui_height() / 2;
		
		for (var _i = 0; _i < array_length(tabs); _i++) {
			tabs[_i].group.xx = xx - width / 2;
			tabs[_i].group.yy = yy - height / 2;
		}
		
		if (array_length(tabs) < 0) return;
		ui_manager.step();
	}
	
	static draw = function() {
		live_name = "simple_ui_tabs:draw";
		if (live_call()) return live_result;
		
		draw_sprite_stretched(spr_dialogue_default, 0, xx - width / 2, yy - height / 2, width, height);
		scribble(title).draw(xx - width / 2 + 7, yy - height / 2 + 7);
		
		// Draw the tabs
		for (var _i = 0; _i < array_length(tabs); _i++) {
			var _s = (selected_tab == _i) ? tabs[_i].sprite_index : tabs[_i].sprite_index + 1;
			
			draw_sprite(spr_tabs, _s, xx + width / 2 - 1, yy - height / 2 + 16 + 23 * _i);	
			
			if (point_in_rectangle(mouse_x, mouse_y, xx + width / 2 - 1, yy - height / 2 + 16 + 23 * _i, xx + width / 2 - 1 + 22, yy - height / 2 + 16 + 23 * _i + 22)) {
				if (mouse_check_button_pressed(mb_left)) {
					selected_tab = _i;	
					ui_manager.set_page(tabs[_i].title);
					audio_play_sound(JDSherbert___Ultimate_UI_SFX_Pack___Cursor___4, 1, 0);
				}
			}
		}
		
		ui_manager.draw();
	}
}

function SimpleUITab(_title, _sprite_index = -1, _group = noone) constructor {
	title			= _title;
	sprite_index	= _sprite_index;
	group			= _group;
}