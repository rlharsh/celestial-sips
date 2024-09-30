function SimpleUITabs(_title, _x, _y, _width, _height) constructor {
	title			= _title;
	xx				= _x;
	yy				= _y;
	width			= _width;
	height			= _height;
	tabs			= [];
	selected_tab	= 0;
	ui_manager		= noone;
	
	static set_ui_manager = function(_ui) {
		ui_manager = _ui;	
	}
	
	static add_tab = function(_tab) {
		array_push(tabs, _tab);
	}
	
	static set_tab = function() {
		if (array_length(tabs) < 0) return;
	}
	
	static step = function() {
		if (array_length(tabs) < 0) return;
	}
	
	static draw = function() {
		if (ui_manager != noone) {
			ui_manager.draw();
		}
	}
}

function SimpleUITab(_title) constructor {
	title	= _title;
	group	= noone;
	
	static step = function() {
		
	}
	
	static draw = function() {
		
	}
	
	static add_group = function() {
		
	}
}