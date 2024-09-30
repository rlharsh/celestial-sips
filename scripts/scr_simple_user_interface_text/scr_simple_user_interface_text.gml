function SimpleText(_x, _y, _text, _parent, _shadow = false, _config = {}, _point_control = false) constructor{
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
	
	text_object	= scribble(_text);
	text_width	= text_object.get_width();
	text_height	= text_object.get_height();
	shadow		= _shadow;
	alignment	= _config[$ "alignment"] ?? UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER;
	point_control			= _point_control;
	parent					= _parent;
	b_x						= _x;
	b_y						= _y;
	
	static step = function() {
		
	}
	
	static draw = function() {
		if (point_control) {
			xx					= b_x;
			yy					= b_y;
		} else {
			xx					= b_x * parent.width / 100;
			yy					= b_y * parent.height / 100;
		}
		
		if (alignment == UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER) {
			xx				= round(xx - text_width / 2);
			yy				= round(yy - text_height / 2);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_LEFT) {
			xx				= round(xx);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.TOP_RIGHT) {
			xx				= round(xx - text_width);
			yy				= round(yy);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_LEFT) {
			xx				= round(xx);
			yy				= round(yy - text_height);
		}
		if (alignment == UI_DISPLAY_ALIGNMENT.BOTTOM_RIGHT) {
			xx				= round(xx - text_width);
			yy				= round(yy - text_height);
		}
		
		if (shadow) {
			text_object.blend(c_black, .6).draw(parent.xx + xx + 1, parent.yy + yy + 1);	
		}
		text_object.blend(c_white, 1).draw(parent.xx + xx, parent.yy + yy);
	}
}