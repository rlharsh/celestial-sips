var _direction = keyboard_check_pressed(vk_pageup) - keyboard_check_pressed(vk_pagedown);
if (_direction != 0) {
	current_waveform = clamp(current_waveform + _direction, 0, 3);
	synth_destroy(synth);
	synth = -1;
	
	// You can't destroy a synth and create a new one on the same frame due to audio queue issues
	call_later(1, time_source_units_frames, function() {
		obj_synth_engine_demo.synth = synth_create(6);
		synth_amp_envelope_adsr(obj_synth_engine_demo.synth, 0.01, 0, 1, 0.1);
		synth_add_osc(obj_synth_engine_demo.synth, obj_synth_engine_demo.current_waveform);
	});
}

if (synth == -1) exit;

for (var i = 0; i < array_length(keys); i++) {
	var _key = keys[i];

	if (keyboard_check_pressed(_key.key) && _key.note_index == -1) {
		_key.note_index = synth_note_on(synth, _key.frequency);
	} else if (keyboard_check_released(_key.key) && _key.note_index > -1) {
		synth_note_off(synth, _key.note_index);
		_key.note_index = -1;
	}
}