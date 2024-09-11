/// @desc Adds an LFO to a synth that can be connected to other parameters
/// @arg {Id.Instance} synth
/// @arg {Real} waveform One of the synth_waveform_* macros
/// @arg {Real} [frequency]
/// @arg {Real} [amount] How strongly to affect connections, between 0 and 1. For pitch, a value of 1 is +/-12 semitones. For panning, a value of 1 is full left and right panning. For amp envelopes, a value of 1 is full volume to quiet, and 0 is no modulation.
/// @arg {Bool} [note_trigger] When true, will reset the LFO phase whenever a note is pressed (and no other notes are pressed)
function synth_add_lfo(synth, waveform, frequency = 5, amount = 0.5, note_trigger = false) {
	var _preset = synth_get_waveform_preset(waveform);
	return synth_add_lfo_ext(synth, _preset.ac, _preset.name, frequency, amount, note_trigger);
}

/// @desc Adds an LFO to a synth using an animation curve as the waveform shape that can be connected to other parameters
/// @arg {Id.Instance} synth
/// @arg {Asset.GMAnimCurve|Struct.AnimCurve} animation_curve
/// @arg {String|Real} curve_name
/// @arg {Real} [frequency]
/// @arg {Real} [amount] How strongly to affect connections, usually between 0 and 1. For pitch, a value of 1 is +/-12 semitones. For panning, a value of 1 is full left and right panning. For amp envelopes, a value of 1 is full volume to quiet, and 0 is no modulation.
/// @arg {Bool} [note_trigger] When true, will reset the LFO phase whenever a note is pressed (and no other notes are pressed)
function synth_add_lfo_ext(synth, animation_curve, curve_name, frequency = 5, amount = 0.5, note_trigger = false) {
	array_push(synth.data.lfos, {
		value: 0,
		channel: animcurve_get_channel(animation_curve, curve_name),
		speed_hz: frequency,
		amount,
		note_trigger,
		i: 0,
		last_i: 0
	});
	return array_length(synth.data.lfos) - 1;
}

/// @desc Connect an LFO to synth panning
/// @arg {Id.Instance} synth
/// @arg {Real} lfo
function synth_connect_lfo_panning(synth, lfo) {
	synth.data.panning_lfo = lfo;
}

/// @desc Disconnects any LFO to a synths panning
/// @arg {Id.Instance} synth
function synth_disconnect_lfo_panning(synth) {
	synth.data.panning_lfo = -1;
}

/// @desc Connect an LFO to synth amp (This will replace any existing ADSR envelope)
/// @arg {Id.Instance} synth
/// @arg {Real} lfo
/// @arg {Real} [release]
function synth_connect_lfo_amp(synth, lfo, release = 0.1) {
	synth.data.amp_envelope = {
		type: "LFO",
		lfo,
		release: release * synth.data.sample_rate,
		raw: { release }
	};
}

/// @desc Remove a previously made LFO
/// @arg {Id.Instance} synth
/// @arg {Real} lfo
function synth_remove_lfo(synth, lfo) {
	synth.data.lfo = array_filter(synth.data.lfo, method({ index }, function(_, i) { return i != index }));
}