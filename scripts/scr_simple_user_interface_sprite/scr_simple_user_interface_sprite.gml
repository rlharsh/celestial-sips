function SimpleSprite(_x, _y, _sprite_index, _image_index, _parent, _config = {}, _point_control = false) constructor{
	point_control			= _point_control;
	
	xx = -1;
	yy = -1;
	
	sprite_index	= _sprite_index;
	image_index		= _image_index;
	alignment		= _config[$ "alignment"] ?? UI_DISPLAY_ALIGNMENT.MIDDLE_CENTER;
	point_control			= _point_control;
	parent					= _parent;
	b_x						= _x;
	b_y						= _y;
	width					= _config[$ "width"] ?? sprite_get_width(sprite_index);
    height					= _config[$ "height"] ?? sprite_get_height(sprite_index);
	poing_control			= _point_control;
	parent					= _parent;

	static step = function() {
		if (point_control) {
			xx					= b_x;
			yy					= b_y;
		} else {
			xx					= b_x * parent.width / 100;
			yy					= b_y * parent.height / 100;
		}
	}
	
	static draw = function() {
		live_name = "simple_sprite:draw";
		if (live_call()) return live_result;
		
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
		
		// draw_set_color(c_black);
		// draw_text(10, 10, string(parent.width));
		// show_debug_message(parent.width);

		draw_sprite_stretched(sprite_index, image_index, xx, yy, width, height);

	}
}