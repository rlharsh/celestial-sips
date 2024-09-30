function SimpleButton(_x, _y, _parent, _config = {}, _point_control = false) constructor {
	point_control			= _point_control;
	
	xx = -1;
	yy = -1;
	
	if (_point_control) {
		xx					= _x;
		yy					= _y;
	} else {
		xx					= _x * _parent.width / 100;
		yy					= _y * _parent.height / 100;
	}
	
	width					= _config[$ "width"]	?? undefined;
	height					= _config[$ "height"]	?? undefined;
	text					= _config[$ "text"]		?? "Undefined";
	icon					= _config[$ "icon"]		?? undefined;
	s_index					= _config[$ "sprite"]	?? spr_button_default;
	callback				= _config[$ "callback"] ?? function() { show_debug_message("Unhandled button event."); };
	alignment				= _config[$ "alignment"] ?? UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER;
	point_control			= _point_control;
	parent					= _parent;
	b_x						= _x;
	b_y						= _y;
	
	_icon_text				= (icon != undefined) ? "[" + icon + ", 0] " : "";
	
	_button_text			= scribble($"[fa_center][fa_middle]{_icon_text} {text}");
	_button_text_width		= _button_text.get_width();
	_button_width			= (width == undefined) ? ((icon == undefined) ? _button_text_width + 14 : _button_text_width + sprite_get_width(icon) + 14) : 100;
	_button_height			= (height == undefined) ? _button_text.get_height() + 10 : 30;
	_button_icon_padding	= (icon == undefined) ? 0 : 6;
	
	_mouse_hovered			= false;
	scale					= 1.0;
	scale_tween				= undefined;
	animation_played		= false;

	static step = function() {
    // Update xx and yy based on alignment and scaling logic
    if (point_control) {
        xx = b_x;
        yy = b_y;
    } else {
        xx = b_x * parent.width / 100;
        yy = b_y * parent.height / 100;
    }

    // Align the button based on its alignment setting
    if (alignment == UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER) {
        xx = round(xx - _button_width / 2);
        yy = round(yy - _button_height / 2);
    }
    if (alignment == UI_DISPLAY_ALIGNMENT.TOP_LEFT) {
        xx = round(xx);
        yy = round(yy);
    }
    if (alignment == UI_DISPLAY_ALIGNMENT.TOP_RIGHT) {
        xx = round(xx - _button_width);
        yy = round(yy);
    }
    if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT) {
        xx = round(xx);
        yy = round(yy - _button_height);
    }
    if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_RIGHT) {
        xx = round(xx - _button_width);
        yy = round(yy - _button_height);
    }

    // Calculate the scaled button dimensions and offsets
    var scaled_width = _button_width * scale;
    var scaled_height = _button_height * scale;
    var scale_offset_x = (scaled_width - _button_width) / 2;
    var scale_offset_y = (scaled_height - _button_height) / 2;

    // Get the mouse position
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;

    // Check if the mouse is within the button's scaled boundaries
    if (point_in_rectangle(_mouse_x, _mouse_y, parent.xx + xx - scale_offset_x, parent.yy + yy - scale_offset_y, parent.xx + xx + scaled_width, parent.yy + yy + scaled_height)) {
        _mouse_hovered = true;

        // Play the hover animation if it hasn't been played yet
        if (!animation_played) {
            TweenFire(self, EaseOutQuad, TWEEN_MODE_ONCE, true, 0, 0.1, "scale", 1.0, 1.1);
            scale_tween = TweenFire(self, EaseInQuad, TWEEN_MODE_ONCE, true, 0.1, 0.1, "scale", 1.1, 1.0);
            animation_played = true;
        }

        // Handle mouse clicks
        if (input_mouse_check_released(mb_left)) {
            audio_play_sound(JDSherbert___Ultimate_UI_SFX_Pack___Cursor___4, 0, 0);
            callback();
        }
        if (input_mouse_check_pressed(mb_left)) {
            TweenFire(self, EaseOutQuad, TWEEN_MODE_ONCE, true, 0, 0.1, "scale", 1.0, 0.9);
            scale_tween = TweenFire(self, EaseInQuad, TWEEN_MODE_ONCE, true, 0.1, 0.1, "scale", 0.9, 1.0);
            animation_played = true;
        }
    } else {
        _mouse_hovered = false;
        animation_played = false;
    }
}

    
    static draw = function() {
	    var scaled_width = _button_width * scale;
	    var scaled_height = _button_height * scale;
	    var scale_offset_x = (scaled_width - _button_width) / 2;
	    var scale_offset_y = (scaled_height - _button_height) / 2;
		// Draw the button background.
		var _sprite_index = (_mouse_hovered) ? 1 : 0;
		if (input_mouse_check(mb_left) && _mouse_hovered) {
			_sprite_index = 2;	
		}
		draw_sprite_stretched(s_index, _sprite_index, xx - scale_offset_x, yy - scale_offset_y, scaled_width, scaled_height + 4);
		// Draw the icon.
		// if (icon != undefined) draw_sprite(icon, 0, round(xx + 6), round(yy + _button_height / 2));
		//_button_text.blend(c_black, .2).draw(round(xx + _button_width / 2 + _button_icon_padding + 1), round(yy + _button_height / 2 + 1));
		_button_text.blend(c_white, 1).draw(round(xx + _button_width / 2), round(yy + _button_height / 2));
	}
}