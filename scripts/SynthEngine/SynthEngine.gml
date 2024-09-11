#macro synth_waveform_sine 0
#macro synth_waveform_saw 1
#macro synth_waveform_square 2
#macro synth_waveform_triangle 3

#macro synth_max_audio_buffers 4

/// @desc Creates a new synthesizer
/// @arg {Real} [polyphony] How many notes can be played at once during live playback
/// @arg {Constant.AudioChannelType} [channels] Sets the synth to be mono or stereo
/// @arg {Constant.BufferDataType} [format] The format audio data should be written as (buffer_u8 or buffer_s16)
/// @arg {Real} [sample_rate] The sample rate to render audio at (8000 - 48000)
function synth_create(polyphony = 4, channels = audio_stereo, format = buffer_s16, sample_rate = 44100) {
	var _audio_buffer_size = round(sample_rate / game_get_speed(gamespeed_fps));
	var _buffers = array_create(synth_max_audio_buffers);
	
	var _sample_size = format == buffer_u8 ? 1 : 2;
	var _channel_size = channels == audio_mono ? 1 : 2;
	var _buffer_size = _audio_buffer_size * _sample_size * _channel_size;
	
	for (var i = 0; i < synth_max_audio_buffers; i++) {
		_buffers[i] = buffer_create(_buffer_size, buffer_fixed, 1);
		buffer_fill(_buffers[i], 0, buffer_u8, 0, _buffer_size);
	}
	
	var _queue = audio_create_play_queue(format, sample_rate, channels);
	
	for (var i = 0; i < synth_max_audio_buffers; i++) {
		audio_queue_sound(_queue, _buffers[i], 0, _buffer_size);
	}
	
	var _audio_play_index = audio_play_sound(_queue, 0, true);
	var _inst = instance_create_depth(0, 0, 0, obj_synth_engine);
	
	var _notes = array_create(polyphony);
	for (var i = 0; i < polyphony; i++) {
		_notes[i] = {
			on: false,
			off: false,
			offi: -1,
			frequency: -1,
			amplitude: -1,
			phase_index: 0,
			phase_offset: 0,
			noise: {
				last_out: 0,
				b: array_create(7, 0)
			},
			i: -1
		};	
	}
	
	_inst.data = {
		lfos: [],
		panning_lfo: -1,
		panning: 0,
		notes: _notes,
		polyphony,
		polyphony_max_amplitude: 1 / polyphony,
		audio_play_index: _audio_play_index,
		queue: _queue,
		buffers: _buffers,
		audio_buffer_size: _audio_buffer_size,
		buffer_size: _buffer_size,
		sample_rate,
		format,
		channels,
		generators: [],
		amp_envelope: {
			type: "ASDR",
			attack: 0,
			decay: 0,
			sustain: 1,
			release: 0,
			raw: {
				attack: 0,
				decay: 0,
				release: 0
			}
		}
	};
	
	return _inst;
}

/// @desc Set the amp envelope of the synth to a standard ADSR shape
/// @arg {Id.Instance} synth
/// @arg {Real} attack
/// @arg {Real} decay
/// @arg {Real} sustain (0 - 1)
/// @arg {Real} release
function synth_amp_envelope_adsr(synth, attack, decay, sustain, release) {
	synth.data.amp_envelope = {
		type: "ASDR",
		raw: {
			attack,
			decay,
			release
		},
		attack: attack * synth.data.sample_rate,
		decay: decay * synth.data.sample_rate,
		release: release * synth.data.sample_rate,
		sustain
	};
}

global.__synth_preset_waves = [
	{ ac: ac_synth_waves_smooth, name: "Sine" },
	{ ac: ac_synth_waves_linear, name: "Saw" },
	{ ac: ac_synth_waves_linear, name: "Square" },
	{ ac: ac_synth_waves_linear, name: "Triangle" }
];

/// @desc Get the animation curve info for a given synth waveform preset
/// @arg {Real} waveform One of the synth_waveform_* macros
function synth_get_waveform_preset(waveform) {
	if (variable_global_exists("__synth_preset_pro_waves")) {
		return variable_global_get("__synth_preset_pro_waves")[waveform];
	} else {
		return global.__synth_preset_waves[waveform];
	}
}

/// @desc Add an oscillator to a synth using an animation curve as the waveform shape
/// @arg {Id.Instance} synth
/// @arg {Asset.GMAnimCurve|Struct.AnimCurve} animation_curve
/// @arg {String|Real} curve_name
/// @arg {Real} [semitone_offset] Default 0 which is the same note, 7 is a perfect fifth, 12 is an octave, etc.
/// @arg {Real} [amp_factor] How loud this oscillator should be (0-1, 1 = full volume)
function synth_add_osc_ext(synth, animation_curve, curve_name, semitone_offset = 0, amp_factor = 1) {
	array_push(synth.data.generators, {
		type: "OSC",
		channel: animcurve_get_channel(animation_curve, curve_name),
		amp_factor,
		semitone_offset,
		render_phase_index: 0,
		poly_phase_indeces: array_create(synth.data.polyphony, 0),
		pitch_lfo: -1
	});
	return array_length(synth.data.generators) - 1;
}

/// @desc Add an oscillator to a synth
/// @arg {Id.Instance} synth
/// @arg {Real} waveform One of the synth_waveform_* macros
/// @arg {Real} [semitone_offset] Default 0 which is the same note, 7 is a perfect fifth, 12 is an octave, etc.
/// @arg {Real} [amp_factor] How loud this oscillator should be (0-1, 1 = full volume)
function synth_add_osc(synth, waveform, semitone_offset = 0, amp_factor = 1) {
	var _preset = synth_get_waveform_preset(waveform);
	return synth_add_osc_ext(synth, _preset.ac, _preset.name, semitone_offset, amp_factor);
}

/// @desc Remove a previously made oscillator, noise, or processor
/// @arg {Id.Instance} synth
/// @arg {Real} generator
function synth_remove_generator(synth, generator) {
	synth.data.generators = array_filter(synth.data.generators, method({ generator }, function(_, i) { return i != generator }));
}

/// @desc Renders synthesizer audio of a single note into a buffer
/// @arg {Id.Instance} synth
/// @arg {Real} length Final length will be this plus amp envelope release
/// @arg {Real} [frequency]
/// @arg {Real} [amplitude] (0-1)
function synth_render_buffer(synth, length, frequency = 440, amplitude = 1) {
	synth = synth.data;
	var _attack = 0;
	var _decay = 0;
	
	if (synth.amp_envelope.type == "ASDR") {
		_attack = synth.amp_envelope.attack;
		_decay = synth.amp_envelope.decay;
	}
	
	length += synth.amp_envelope.raw.release;
	
	var _total_frames = ceil(length * synth.sample_rate);
	var _total_bytes = _total_frames * (synth.format == buffer_u8 ? 1 : 2);
	var _buffer = buffer_create(_total_bytes * (synth.channels == audio_mono ? 1 : 2), buffer_fixed, 1);
	
	var _generator_total = 0;
	for (var g = 0; g < _generators_count; g++) {
		if (synth.generators[g].type == "NOISE" || synth.generators[g].type == "OSC") {
			_generator_total += synth.generators[g].amp_factor;
		} else {
			_generator_total += 1;	
		}
	}
	
	var _generators_count = array_length(synth.generators);
	var _max_amplitude = amplitude > _generator_total ? amplitude * _generator_total : amplitude / _generator_total;
	
	array_foreach(synth.generators, function(g) {
		if (g.type == "NOISE") {
			g.last_out = 0;
			g.b = array_create(7, 0);
		}
	});
	
	var _lfo_count = array_length(synth.lfos);
	
	var _last_asdr_amp = 0;
	for (var i = 0; i < _total_bytes; ++i) {
		var _amp = 0;
		
		for (var lfo = 0; lfo < _lfo_count; lfo++) {
			var _period = synth.sample_rate / synth.lfos[lfo].speed_hz;
			var _pos = (i % _period) / _period;
			synth.lfos[lfo].value = animcurve_channel_evaluate(synth.lfos[lfo].channel, _pos);
			synth.lfos[lfo].value = (synth.lfos[lfo].value + 1) / 2;
		}

		if (synth.amp_envelope.type == "ASDR") {
			if (i > _total_frames - synth.amp_envelope.release) {
				_amp = _last_asdr_amp * ((_total_frames - i) / synth.amp_envelope.release);
			} else {
				if (i <= _attack) {
					_amp = i / _attack;
					_last_asdr_amp = _amp;
				} else if (i <= _attack + _decay) {
					_amp = 1 - (1 - synth.amp_envelope.sustain) * ((i - _attack) / _decay);
					_last_asdr_amp = _amp;
				} else if (i <= _total_frames - synth.amp_envelope.release) {
					_amp = synth.amp_envelope.sustain;
					_last_asdr_amp = _amp;
				} else {
					_amp = _last_asdr_amp * ((_total_frames - i) / synth.amp_envelope.release);
				}
			}
		} else if (synth.amp_envelope.type == "LFO") {
			_amp = 1 - (synth.lfos[synth.amp_envelope.lfo].value * synth.lfos[synth.amp_envelope.lfo].amount);
				
			if (i > _total_frames - synth.amp_envelope.release) {
				_amp = _amp * ((_total_frames - i) / synth.amp_envelope.release);
			}
		}

		_amp *= _max_amplitude;
		var _pre_amp = _amp;
		
		var _value = 0;
		for (var j = 0; j < _generators_count; j++) {
			_amp = _pre_amp;
			var _inner_value = 0;
			
			if (synth.generators[j].type == "OSC") {
				_amp *= synth.generators[j].amp_factor;
				var _frequency = frequency * power(2, synth.generators[j].semitone_offset / 12);
				
				if (synth.generators[j].pitch_lfo != -1) {
					var _lfo_amount = synth.lfos[synth.generators[j].pitch_lfo].amount * 12;
					var _lfo_value = synth.lfos[synth.generators[j].pitch_lfo].value;
					var _lfo_output = lerp(_lfo_amount * -1, _lfo_amount, _lfo_value);
					var _semitone_offset = power(2, _lfo_output / 12);
					_frequency *= _semitone_offset;
				}

				var _phase_index = synth.generators[j].render_phase_index;
				var _phase_delta = _frequency / synth.sample_rate;
				_phase_index += _phase_delta;
				_phase_index = _phase_index % 1;
				synth.generators[j].render_phase_index = _phase_index;
				_inner_value = animcurve_channel_evaluate(synth.generators[j].channel, _phase_index) * _amp;
			} else if (synth.generators[j].type == "NOISE") {
				_amp *= synth.generators[j].amp_factor;
				var _white = random_range(-1, 1);
				
				switch (synth.generators[j].noise_type) {
					case synth_noise_white:
						_inner_value = _white * _amp;
						break;
					case synth_noise_brown:
						_inner_value = (synth.generators[j].last_out + (0.05 * _white)) / 1.05;
						synth.generators[j].last_out = _inner_value;
						_inner_value *= _amp;
						break;
					case synth_noise_pink:
						synth.generators[j].b[0] = 0.99886 * synth.generators[j].b[0] + _white * 0.0555179;
						synth.generators[j].b[1] = 0.99332 * synth.generators[j].b[1] + _white * 0.0750759;
						synth.generators[j].b[2] = 0.96900 * synth.generators[j].b[2] + _white * 0.1538520;
						synth.generators[j].b[3] = 0.86650 * synth.generators[j].b[3] + _white * 0.3104856;
						synth.generators[j].b[4] = 0.55000 * synth.generators[j].b[4] + _white * 0.5329522;
						synth.generators[j].b[5] = -0.7616 * synth.generators[j].b[5] - _white * 0.0168980;
						_inner_value = synth.generators[j].b[0] + synth.generators[j].b[1] + synth.generators[j].b[2] + synth.generators[j].b[3] + synth.generators[j].b[4] + synth.generators[j].b[5] + synth.generators[j].b[6] + _white * 0.5362;
						_inner_value *= 0.11;
						synth.generators[j].b[6] = _white * 0.115926;
						break;
				}
			} else if (synth.generators[j].type == "CPU") {
				_inner_value = synth.generators[j].callback({
					i, frequency, length
				}, _amp, synth);
			}
			
			if (synth.format == buffer_u8) {
				_inner_value = ((_inner_value + 1) / 2) * 255;
			} else {
				_inner_value *= 32767;
			}
			_value += _inner_value;
		}
		
		if (synth.channels == audio_mono) {
			buffer_write(_buffer, synth.format, _value);
		} else {
			var _left_lfo_pan = 1;
			var _right_lfo_pan = 1;
			
			if (synth.panning_lfo != -1) {
				var _lfo_panning = synth.lfos[synth.panning_lfo].value;
				_left_lfo_pan = _lfo_panning < 0.5 ? 1 : 1 - ((_lfo_panning - 0.5) / 0.5);
				_right_lfo_pan = _lfo_panning > 0.5 ? 1 : (_lfo_panning / 0.5);
				
				_left_lfo_pan = lerp(1 - synth.lfos[synth.panning_lfo].amount, 1, _left_lfo_pan);
				_right_lfo_pan = lerp(1 - synth.lfos[synth.panning_lfo].amount, 1, _right_lfo_pan);
			}
			
			var _left_pan = synth.panning < 0 ? 1 : 1 - abs(synth.panning);
			var _right_pan = synth.panning > 0 ? 1 : 1 - abs(synth.panning);
			
			buffer_write(_buffer, synth.format, _value * (_left_pan * _left_lfo_pan));
			buffer_write(_buffer, synth.format, _value * (_right_pan * _right_lfo_pan));
		}
	}

	return _buffer;
}

/// @desc Renders synthesizer audio of a single note into a buffer and sound asset
/// @arg {Id.Instance} synth
/// @arg {Real} length
/// @arg {Real} [frequency]
/// @arg {Real} [amplitude] (0-1)
function synth_render_audio(synth, length, frequency = 440, amplitude = 1) {
	var buffer = synth_render_buffer(synth, length, frequency, amplitude);
	var sound = audio_create_buffer_sound(buffer, synth.data.format, synth.data.sample_rate, 0, buffer_get_size(buffer), synth.data.channels);
	
	return {
		buffer,
		sound,
		cleanup: method({ sound, buffer }, function() {
			audio_free_buffer_sound(sound);
			buffer_delete(buffer);
		})
	};
}

/// @desc Renders synthesizer audio of a single note and immediately plays it, cleaning up memory once playback finishes
/// @arg {Id.Instance} synth
/// @arg {Real} length
/// @arg {Real} [frequency]
/// @arg {Real} [amplitude] (0-1)
/// @arg {Real} [cleanup_offset] How long in seconds to wait before cleaning up the audio
function synth_play_audio(synth, length, frequency = 440, amplitude = 1, cleanup_offset = 1) {
	var _result = synth_render_audio(synth, length, frequency, amplitude);
	audio_play_sound(_result.sound, 1, false);
	call_later(length + synth.data.amp_envelope.release + cleanup_offset, time_source_units_seconds, method({ _result }, function() {
		_result.cleanup();
	}));
}

/// @desc Begin playing a note on a synthesizer
/// @arg {Id.Instance} synth
/// @arg {Real} [frequency]
/// @arg {Real} [amplitude] (0-1)
function synth_note_on(synth, frequency = 440, amplitude = 1) {
	var _note_index = -1;
	var _existing_note_on = false;
	
	for (var i = 0; i < synth.data.polyphony; i++) {
		if (synth.data.notes[i].on) {
			_existing_note_on = true;
			continue;
		} else if (_note_index == -1) {
			_note_index = i;
		}
	}
	
	if (_note_index == -1) return -1;
	
	if (!_existing_note_on) {
		for (var i = 0; i < array_length(synth.data.lfos); i++) {
			var _lfo = synth.data.lfos[i];
			if (_lfo.note_trigger) {
				_lfo.i = 0;
				_lfo.last_i = 0;
			}
		}
	}
	
	synth.data.notes[_note_index].on = true;
	synth.data.notes[_note_index].off = false;
	synth.data.notes[_note_index].offi = 0;
	synth.data.notes[_note_index].phase_index = 0;
	synth.data.notes[_note_index].frequency = frequency;
	synth.data.notes[_note_index].amplitude = amplitude;
	synth.data.notes[_note_index].i = 0;
	synth.data.notes[_note_index].noise.last_out = 0;
	synth.data.notes[_note_index].noise.b = array_create(7, 0);
	
	return _note_index;
}

/// @desc Stop playing a previously played note (and trigger its amp envelope release)
/// @arg {Id.Instance} synth
/// @arg {Real} note_index
function synth_note_off(synth, note_index) {
	if (note_index == -1) return;
	synth.data.notes[note_index].off = true;
	synth.data.notes[note_index].offi = synth.data.notes[note_index].i + synth.data.amp_envelope.release;
}

/// @desc Play a note on a synthesizer for a set length of time
/// @arg {Id.Instance} synth
/// @arg {Real} length
/// @arg {Real} [frequency]
/// @arg {Real} [amplitude] (0-1)
function synth_note_on_ext(synth, length, frequency = 440, amplitude = 1) {
	var _note_index = synth_note_on(synth, frequency, amplitude);
	call_later(length, time_source_units_seconds, method({ synth, _note_index }, function() {
		synth_note_off(synth, _note_index);
	}));
}

/// @desc Destroy a previously created synth
/// @arg {Id.Instance} synth
function synth_destroy(synth) {
	instance_destroy(synth);
}

/// @desc Change the stereo panning of a synth (has no effect for mono channel synths)
/// @arg {Id.Instance} synth
/// @arg {Real} [panning] Left/right panning between -1 and 1, where -1 is all the way left and 1 is all the way right.
function synth_set_panning(synth, panning = 0) {
	synth.data.panning = clamp(panning, -1, 1);
}