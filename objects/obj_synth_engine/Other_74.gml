if (is_undefined(data)) exit;
if (async_load[? "queue_id"] != data.queue) exit;
if (async_load[? "queue_shutdown"] == 1) exit;

var _generators_count = array_length(data.generators);

for (var i = 0; i < synth_max_audio_buffers; i++) {
	var _buffer = data.buffers[i];
	if (async_load[? "buffer_id"] != _buffer) continue;
	buffer_seek(_buffer, buffer_seek_start, 0);
	
	var _lfo_count = array_length(data.lfos);
	for (var lfo = 0; lfo < _lfo_count; lfo++) {
		data.lfos[lfo].last_i = data.lfos[lfo].i;
	}
	
	var _generator_total = 0;
	for (var g = 0; g < _generators_count; g++) {
		if (data.generators[g].type == "NOISE" || data.generators[g].type == "OSC") {
			_generator_total += data.generators[g].amp_factor;
		} else {
			_generator_total += 1;	
		}
	}
	
	var _out = array_create(data.audio_buffer_size, 0);
	for (var p = 0; p < data.polyphony; p++) {
		var _note = data.notes[p];
		if (!_note.on) continue;
		
		for (var lfo = 0; lfo < _lfo_count; lfo++) {
			data.lfos[lfo].i = data.lfos[lfo].last_i;
		}
		
		var _max_amplitude = _note.amplitude > _generator_total ? _note.amplitude * _generator_total : _note.amplitude / _generator_total;
		_max_amplitude *= data.polyphony_max_amplitude;
		
		for (var j = 0; j < data.audio_buffer_size; j++) {
			var _amp = 1;
			
			for (var lfo = 0; lfo < _lfo_count; lfo++) {
				var _period = data.sample_rate / data.lfos[lfo].speed_hz;
				var _pos = (data.lfos[lfo].i % _period) / _period;
				data.lfos[lfo].value = animcurve_channel_evaluate(data.lfos[lfo].channel, _pos);
				data.lfos[lfo].value = (data.lfos[lfo].value + 1) / 2;
				data.lfos[lfo].i++;
			}
			
			if (data.amp_envelope.type == "ASDR") {
				if (_note.off) {
					_amp = _note.amplitude * ((_note.offi - _note.i) / data.amp_envelope.release);
					if (_note.i >= _note.offi) _note.on = false;
				} else {
					if (_note.i <= data.amp_envelope.attack) {
						_amp = _note.i / data.amp_envelope.attack;
					} else if (_note.i <= data.amp_envelope.attack + data.amp_envelope.decay) {
						_amp = 1 - (1 - data.amp_envelope.sustain) * ((_note.i - data.amp_envelope.attack) / data.amp_envelope.decay);
					} else {
						_amp = data.amp_envelope.sustain;	
					}
					
					_note.amplitude = _amp;
				}
			} else if (data.amp_envelope.type == "LFO") {
				_amp = 1 - (data.lfos[data.amp_envelope.lfo].value * data.lfos[data.amp_envelope.lfo].amount);
				
				if (_note.off) {
					_amp = _amp * ((_note.offi - _note.i) / data.amp_envelope.release);
					if (_note.i >= _note.offi) _note.on = false;
				}
			}
			
			_amp *= _max_amplitude;
			var _pre_amp = _amp;
			
			var _value = 0;
			for (var g = 0; g < _generators_count; g++) {
				_amp = _pre_amp;
				
				var _inner_value = 0;
				
				if (data.generators[g].type == "OSC") {
					_amp *= data.generators[g].amp_factor;
					var _frequency = _note.frequency * power(2, data.generators[g].semitone_offset / 12);
					
					if (data.generators[g].pitch_lfo != -1) {
						var _lfo_amount = data.lfos[data.generators[g].pitch_lfo].amount * 12;
						var _lfo_value = data.lfos[data.generators[g].pitch_lfo].value;
						var _lfo_output = lerp(_lfo_amount * -1, _lfo_amount, _lfo_value);
						var _semitone_offset = power(2, _lfo_output / 12);
						_frequency *= _semitone_offset;
					}
					
					var _phase_index = data.generators[g].poly_phase_indeces[p];
					var _phase_delta = _frequency / data.sample_rate;
					_phase_index += _phase_delta;
					_phase_index = _phase_index % 1;
					data.generators[g].poly_phase_indeces[p] = _phase_index;
					_inner_value = animcurve_channel_evaluate(data.generators[g].channel, _phase_index) * _amp;
					
				} else if (data.generators[g].type == "NOISE") {
					_amp *= data.generators[g].amp_factor;
					var _white = random_range(-1, 1);
					
					switch (data.generators[g].noise_type) {
						case synth_noise_white:
							_inner_value = _white * _amp;
							break;
						case synth_noise_brown:
							_inner_value = (_note.noise.last_out + (0.05 * _white)) / 1.05;
							_note.noise.last_out = _inner_value;
							_inner_value *= _amp;
							break;
						case synth_noise_pink:
							_note.noise.b[0] = 0.99886 * _note.noise.b[0] + _white * 0.0555179;
							_note.noise.b[1] = 0.99332 * _note.noise.b[1] + _white * 0.0750759;
							_note.noise.b[2] = 0.96900 * _note.noise.b[2] + _white * 0.1538520;
							_note.noise.b[3] = 0.86650 * _note.noise.b[3] + _white * 0.3104856;
							_note.noise.b[4] = 0.55000 * _note.noise.b[4] + _white * 0.5329522;
							_note.noise.b[5] = -0.7616 * _note.noise.b[5] - _white * 0.0168980;
							_inner_value = _note.noise.b[0] + _note.noise.b[1] + _note.noise.b[2] + _note.noise.b[3] + _note.noise.b[4] + _note.noise.b[5] + _note.noise.b[6] + _white * 0.5362;
							_inner_value *= 0.11;
							_inner_value *= _amp;
							_note.noise.b[6] = _white * 0.115926;
							break;
					}
				} else if (data.generators[g].type == "CPU") {
					_inner_value = data.generators[g].callback(_note, _amp, data);
				}
				
				if (data.format == buffer_u8) {
					_inner_value = ((_inner_value + 1) / 2) * 255;
				} else {
					_inner_value *= 32767;
				}
				_value += _inner_value;
			}
			
			_out[j] += _value;
			_note.i++;
		}
	}
	
	for (var n = 0; n < data.audio_buffer_size; n++) {
		if (data.channels == audio_mono) {
			buffer_write(_buffer, data.format, _out[n]);
		} else {
			var _left_lfo_pan = 1;
			var _right_lfo_pan = 1;
			
			if (data.panning_lfo != -1) {
				var _lfo_panning = data.lfos[data.panning_lfo].value;
				
				_left_lfo_pan = (_lfo_panning < 0.5 ? 1 : 1 - ((_lfo_panning - 0.5) / 0.5));
				_right_lfo_pan = (_lfo_panning > 0.5 ? 1 : _lfo_panning / 0.5);
				
				_left_lfo_pan = lerp(1 - data.lfos[data.panning_lfo].amount, 1, _left_lfo_pan);
				_right_lfo_pan = lerp(1 - data.lfos[data.panning_lfo].amount, 1, _right_lfo_pan);
			}
			
			var _left_pan = data.panning < 0 ? 1 : 1 - abs(data.panning);
			var _right_pan = data.panning > 0 ? 1 : 1 - abs(data.panning);
			
			buffer_write(_buffer, data.format, _out[n] * (_left_pan * _left_lfo_pan));
			buffer_write(_buffer, data.format, _out[n] * (_right_pan * _right_lfo_pan));
		}
	}
	
	audio_queue_sound(data.queue, _buffer, 0, data.buffer_size);
	break;
}

if (!audio_is_playing(data.audio_play_index)) {
	data.audio_play_index = audio_play_sound(data.queue, 0, true);
}