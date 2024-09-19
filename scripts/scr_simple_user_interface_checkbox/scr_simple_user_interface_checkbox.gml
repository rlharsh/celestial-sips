function SimpleCheckbox(_x, _y, _checked, _parent, _config = {}, _point_control = false) constructor {
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
	checked					= _checked;
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
			xx				= round(xx - _button_width / 2);
			yy				= round(yy - _button_height / 2);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_LEFT) {
			xx				= round(xx);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_RIGHT) {
			xx				= round(xx - _button_width);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT) {
			xx				= round(xx);
			yy				= round(yy - _button_height);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_RIGHT) {
			xx				= round(xx - _button_width);
			yy				= round(yy - _button_height);
		}
		
		var _mouse_x	= mouse_x;
		var _mouse_y	= mouse_y;
		
		if (point_in_rectangle(_mouse_x, _mouse_y, xx, yy, xx + sprite_get_width(spr_checkbox), yy + sprite_get_height(spr_checkbox))) {
			if (mouse_check_button_pressed(mb_left)) {
				audio_play_sound(JDSherbert___Ultimate_UI_SFX_Pack___Cursor___4, 0, 0);
				checked = !checked;	
			}
		}
	}
	
	static draw = function() {
		var _s_index = (checked) ? 1 : 0;
		draw_sprite(spr_checkbox, _s_index, xx, yy);
	}
}