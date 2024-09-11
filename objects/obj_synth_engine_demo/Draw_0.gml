draw_set_font(fnt_synth_engine_demo);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(32, 32, "SynthEngine Demo\n\nPlay the synth using your computer keyboard! Use letters ASDFGHJK\n\nUse Page Up and Page Down to change waveforms\nCurrent waveform: " + waveform_names[current_waveform]);

if (synth == -1) exit;

var _last_point = [data_graph_x, data_graph_y + (data_graph_height / 2)];
for (var i = 0; i < buffer_segments_to_draw; i++) {
	var _buffer = synth.data.buffers[i];
	var _add = round(synth.data.buffer_size / data_graph_width);
	
	var _x_offset = 0;
	for (var j = 0; j < synth.data.buffer_size; j += _add) {
		var _v = buffer_peek(_buffer, j, synth.data.format);
		if (is_undefined(_v)) _v = 0;
		
		if (synth.data.format == buffer_u8) {
			_v = _v / 255;
		} else {
			_v = (_v + 32768) / 65535;
		}
		
		var _x = data_graph_x + (data_graph_width * i) + _x_offset;
		var _y = data_graph_y + (data_graph_height - (_v * data_graph_height));
		draw_line(_last_point[0], _last_point[1], _x, _y);
		_last_point = [_x, _y];
		
		_x_offset++;
	}
}