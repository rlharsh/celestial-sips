function SimpleGroup(_name, _x, _y, _width = undefined, _height = display_get_gui_height(), _backdrop = false, _adaptive_width = false) constructor {
	name				= _name;
	xx					= _x;
	yy					= _y;
	width				= (_width == undefined) ? round(display_get_gui_width()) : round(_width);
	height				= _height;
	controls			= [];
	surface				= -1;
	backdrop			= _backdrop;
	adaptive_width		= _adaptive_width;
	initial_gui_width	= width;
	
	static add_control = function(_control) {
		_control.xx += xx;
		_control.yy += yy;
		
		array_push(controls, _control);
	}
	
	static step = function() {
		if (adaptive_width) {
			var _current_gui_width	= display_get_gui_width();
			var _scale_factor		= _current_gui_width / initial_gui_width;
			
			width					= round(initial_gui_width * _scale_factor);
		}
		
		for (var _i = 0; _i < array_length(controls); _i++) {
			controls[_i].step();	
		}
	}
	
	static draw = function() {
		if (!surface_exists(surface) || surface_get_width(surface) != width || surface_get_height(surface) != height) {
            if (surface_exists(surface)) {
                surface_free(surface);
			}
            surface = surface_create(width, height);
        }
		surface_set_target(surface);
        draw_clear_alpha(c_white, 0);
		
		if (backdrop) {
			draw_set_alpha(.8);
			draw_set_color(c_black);
			draw_rectangle(xx, yy, width, height, false);
			draw_set_color(c_white);
			draw_set_alpha(1);
		}
		
		for (var _i = 0; _i < array_length(controls); _i++) {
			controls[_i].draw();
		}
		surface_reset_target();
		draw_surface(surface, round(xx), round(yy));
	}
	
	static destroy = function() {
		if (surface_exists(surface)) {
			surface_free(surface);	
		}
	}
}