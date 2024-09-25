function SimpleIconButton(_x, _y, _parent, _config = undefined, _point_control = false) constructor {
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
	icon			= _config[$ "icon"] ?? undefined;
	callback		= _config[$ "callback"] ?? function() { show_debug_message("Unhandled icon event."); };
	width			= (icon == undefined) ? 24 : sprite_get_width(icon) + 8;
	height			= (icon == undefined) ? 24 : sprite_get_height(icon) + 8;
	_mouseover		= _config[$ "mouseover"] ? _config.mouseover : false;
	_mouse_hovered	= false;
	alignment		= _config[$ "alignment"] ?? UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER;
	point_control			= _point_control;
	parent					= _parent;
	b_x						= _x;
	b_y						= _y;
	
	static step = function() {
		if (point_control) {
			xx					= b_x;
			yy					= b_y;
		} else {
			xx					= b_x * parent.width / 100;
			yy					= b_y * parent.height / 100;
		}
		
		if (alignment == UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER) {
			xx				= round(xx - width / 2);
			yy				= round(yy - height / 2);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_LEFT) {
			xx				= round(xx);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_RIGHT) {
			xx				= round(xx - width);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT) {
			xx				= round(xx);
			yy				= round(yy - height);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_RIGHT) {
			xx				= round(xx - width);
			yy				= round(yy - height);
		}
		var _mouse_x = mouse_x;
		var _mouse_y = mouse_y;
		
		if (point_in_rectangle(_mouse_x, _mouse_y, xx, yy, xx + width, yy + height)) {
			_mouse_hovered = true;	
			if (input_mouse_check_released(mb_left)) {
				audio_play_sound(JDSherbert___Ultimate_UI_SFX_Pack___Cursor___4, 0, 0);
				callback();
			}
		} else {
			_mouse_hovered = false;	
		}
	}
	
	static draw = function() {
		live_name = "simple_icon_button:draw";
		if (live_call()) return live_result;
		
		var _i_index = (_mouse_hovered) ? 1 : 0;
		draw_sprite_stretched(spr_button_icon_default, _i_index, xx, yy, width, height);
		
		if (icon != undefined) {
			if (_mouseover && _mouse_hovered) {
				draw_sprite(icon, 1, xx + width / 2 - sprite_get_width(icon)  / 2, yy + height / 2 - sprite_get_height(icon) / 2);		
			} else {
				draw_sprite(icon, 0, xx + width / 2 - sprite_get_width(icon)  / 2, yy + height / 2 - sprite_get_height(icon) / 2);		
			}
		}
	}
}