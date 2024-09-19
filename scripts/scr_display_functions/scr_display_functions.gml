enum ASPECT {
	_16X9,
	_16X10,
	_21X9,
	_1X1,
	_4X3,
	_9X16,
	_5X4
}

function get_primary_aspect_ratio() {
	var _width	= display_get_width();
	var _height = display_get_height();
	
	var _gcd			= get_gcd(_width, _height);
	var _aspect_width	= _width / _gcd;
	var _aspect_height	= _height / _gcd;
	
	if (_aspect_width == 64 && _aspect_height == 27) {
		set_aspect(ASPECT._21X9);
	} else if (_aspect_width == 16	&& _aspect_height == 9) {
		set_aspect(ASPECT._16X9);
	} else if (_aspect_width == 4	&& _aspect_height == 3) {
		set_aspect(ASPECT._4X3);
	} else if (_aspect_width == 16	&& _aspect_height == 10) {
		set_aspect(ASPECT._16X10);
	} else if (_aspect_width == 5	&& _aspect_height == 4) {
		set_aspect(ASPECT._5X4);
	}
}

function set_aspect(argument0) {
	with(obj_controller_gui)
	{
		switch(argument0)
		{
			case ASPECT._16X9: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(16/9);
				break;
			case ASPECT._21X9: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(21/9);
				break;
			case ASPECT._4X3: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(4/3);
				break;
			case ASPECT._1X1: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT;
				break;
			case ASPECT._9X16: 
				current_width = BASE_HEIGHT;
				current_height = BASE_HEIGHT;
				break;
		}
	
		//instance_create_depth(0,0,-1000,obj_screen_fade);
		RESIZE_APP_SURFACE;
		RESIZE_WINDOW;
	}
}

function get_gcd(_a, _b) {
	while (_b != 0) {
		var _temp = _b;
		_b = _a mod _b;
		_a = _temp;
	}
	return _a;
}

function set_font(_font) {
	if (instance_exists(obj_controller_font)) {
		var _font_controller		= obj_controller_font;
		var _font_array_length		= array_length(_font_controller.fonts_database);
		
		for (var _i = 0; _i < _font_array_length; _i++) {
			if (_font_controller.fonts_database[_i].name == _font) {
				_font_controller.default_font = _font_controller.fonts_database[_i];
				draw_set_font(_font_controller.default_font.font_ref);
				scribble_font_set_default(_font_controller.fonts_database[_i].name);
			}
		}
	}
}