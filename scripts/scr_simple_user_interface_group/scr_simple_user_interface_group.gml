function SimpleGroup(_name, _x, _y, _width = undefined, _height = display_get_gui_height(), _backdrop = false, _adaptive_width = false, _config = {}) constructor {
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
	_s_x				= _x;
	_s_y				= _y;
	center_x			= _config[$ "center_x"] ?? false;
	center_y			= _config[$ "center_y"] ?? false;
	
	static add_control = function(_control) {
		_control.xx += xx;
		_control.yy += yy;
		
		array_push(controls, _control);
	}
	
	static step = function() {
	    var current_gui_width  = display_get_gui_width();
	    var current_gui_height = display_get_gui_height();
    
	    if (adaptive_width) {
	        var scale_factor = current_gui_width / initial_gui_width;
	        width = round(initial_gui_width * scale_factor);
	    }

	    // Recalculate center position
	    if (center_x) {
	        xx = round(current_gui_width / 2 - (width / 2));
	    }
	    if (center_y) {
	        yy = round(current_gui_height / 2 - (height / 2));
	    }

	    // Update controls positions if needed
	    for (var i = 0; i < array_length(controls); i++) {
	        controls[i].step();
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

    // Draw backdrop correctly
    draw_set_color(c_white);
    if (backdrop) {
		
        draw_set_alpha(1);
        draw_set_color(c_red);
        draw_rectangle(0, 0, width, height, false); // (0, 0) since we're drawing relative to the surface
        draw_set_color(c_white);
        draw_set_alpha(1);
		
    }

    // Draw all controls
    for (var i = 0; i < array_length(controls); i++) {
        controls[i].draw();
    }
	
	//draw_text(10, 10, $"WIDTH: {width}\nXX: {xx}\nYY: {yy}");

    surface_reset_target();
    draw_surface(surface, round(xx), round(yy)); // Draw the surface at the calculated position
}
	
	static destroy = function() {
		if (surface_exists(surface)) {
			surface_free(surface);	
		}
	}
}