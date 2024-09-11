global._mt_constants = {
	l2: ln(2),
	l440: ln(440),
	letters: ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
};

/// @desc Get the note frequency for a given MIDI note number
/// @arg {Real} note_number MIDI note number (0-127)
/// @arg {Real} [a] Frequency of A4 (default: 440)
function mt_midi_note_frequency(note_number, a = 440) {
	return a * power(2, ((note_number - 69) / 12));
}

/// @desc This function will precalculate all MIDI frequencies into an array
function mt_precalculate_all_frequencies() {
	var _frequencies = [];
	for (var i = 0; i < 128; i++) {
		array_push(_frequencies, mt_midi_note_frequency(i));
	}
	return _frequencies;
}

/// @desc Get the MIDI note number for a given note letter, octave, and sharpness
/// @arg {String} note_letter The letter of the note ("a", "b", "c", "d", "e", "f", "g")
/// @arg {Real} octave The octave of the note (-1 through 9)
/// @arg {Bool} [sharp] Whether the note is sharp or note (default: false)
function mt_midi_note_number_ext(note_letter, octave, sharp = false) {
	var _note_number = 0;
	switch (string_upper(note_letter)) {
		case "C": _note_number = 0; break;
		case "D": _note_number = 2; break;
		case "E": _note_number = 4; break;
		case "F": _note_number = 5; break;
		case "G": _note_number = 7; break;
		case "A": _note_number = 9; break;
		case "B": _note_number = 11; break;
	}
	
	if (sharp) _note_number++;
	_note_number += (octave + 1) * 12;
	return _note_number;
}

/// @desc Get the MIDI note number for a given note in scientific notation
/// @arg {String} note The note you want to parse (i.e. "A#6", "B5", "C4")
function mt_midi_note_number(note) {
	var _parsed_note = mt_note_scientific_parse(note);
	return mt_midi_note_number_ext(_parsed_note.letter, _parsed_note.octave, _parsed_note.sharp);
}

/// @desc Takes a note's scientific notation and returns its letter, octave, and sharpness
/// @arg {String} note The note you want to parse (i.e. "A#6", "B5", "C4")
function mt_note_scientific_parse(note) {
	var _letter = string_char_at(note, 1);
	var _sharp = false;
	var _octave = 0;
	
	if (string_length(note) == 3) {
		_sharp = true;
		_octave = string_char_at(note, 3);
	} else {
		_octave = string_char_at(note, 2);	
	}
	
	return {
		letter: _letter,
		sharp: _sharp,
		octave: real(_octave)
	};
}

/// @desc Get the frequency of a note given its letter, octave, and sharpness
/// @arg {String} note_letter The letter of the note ("a", "b", "c", "d", "e", "f", "g")
/// @arg {Real} octave The octave of the note (-1 through 9)
/// @arg {Bool} [sharp] Whether the note is sharp or note (default: false)
function mt_note_frequency_ext(note_letter, octave, sharp = false) {
	var _note_number = mt_midi_note_number_ext(note_letter, octave, sharp);
	return mt_midi_note_frequency(_note_number);
}

/// @desc Get the frequency of a note given its scientific notation, which is a string containing the letter, an optional sharp (#), and the octave number.
/// @arg {String} note The note you want to get the frequency of in scientific notation (i.e. "A#6", "B5", "C4")
function mt_note_frequency(note) {
	var _parsed_note = mt_note_scientific_parse(note);
	return mt_note_frequency_ext(_parsed_note.letter, _parsed_note.octave, _parsed_note.sharp);
}

/// @desc Returns the pitch multiplier you need to play a sound with a target note as the same frequency as a root note
/// @arg {String} root_note The note you want to play the frequency of in scientific notation
/// @arg {String} target_note The note you have and want to pitch adjust in scientific notation
function mt_frequency_pitch(root_note, target_note) {
	return mt_note_frequency(root_note) / mt_note_frequency(target_note);
}

enum NoteDivision {
	WHOLE,
	WHOLE_DOTTED,
	WHOLE_TRIPLET,
	HALF,
	HALF_DOTTED,
	HALF_TRIPLET,
	QUARTER,
	QUARTER_DOTTED,
	QUARTER_TRIPLET,
	EIGHTH,
	EIGHTH_DOTTED,
	EIGHTH_TRIPLET,
	SIXTEENTH,
	SIXTEENTH_DOTTED,
	SIXTEENTH_TRIPLET,
	THIRTY_SECOND,
	THIRTY_SECOND_DOTTED,
	THIRTY_SECOND_TRIPLET,
	SIXTY_FOURTH,
	SIXTY_FOURTH_DOTTED,
	SIXTY_FOURTH_TRIPLET
}

/// @desc Returns the length of a note division in seconds, given a bpm (treating one quarter note as a beat)
/// @arg {Real} bpm
/// @arg {Real} division One of "NoteDivision" enum
function mt_get_note_length(bpm, division) {
	var _quarter = 60 / bpm;
	switch (division) {
		case NoteDivision.WHOLE: return _quarter * 4;	
		case NoteDivision.WHOLE_DOTTED: return (_quarter * 4) + (_quarter * 2);
		case NoteDivision.WHOLE_TRIPLET: return (_quarter * 4) * (2 / 3);
		case NoteDivision.HALF: return _quarter * 2;
		case NoteDivision.HALF_DOTTED: return (_quarter * 2) + (_quarter);
		case NoteDivision.HALF_TRIPLET: return (_quarter * 2) * (2 / 3);
		case NoteDivision.QUARTER: return _quarter;
		case NoteDivision.QUARTER_DOTTED: return (_quarter) + (_quarter / 2);
		case NoteDivision.QUARTER_TRIPLET: return (_quarter) * (2 / 3);
		case NoteDivision.EIGHTH: return _quarter / 2;
		case NoteDivision.EIGHTH_DOTTED: return (_quarter / 2) + (_quarter / 4);
		case NoteDivision.EIGHTH_TRIPLET: return (_quarter / 2) * (2 / 3);
		case NoteDivision.SIXTEENTH: return _quarter / 4;
		case NoteDivision.SIXTEENTH_DOTTED: return (_quarter / 4) + (_quarter / 8);
		case NoteDivision.SIXTEENTH_TRIPLET: return (_quarter / 4) * (2 / 3);
		case NoteDivision.THIRTY_SECOND: return _quarter / 8;
		case NoteDivision.THIRTY_SECOND_DOTTED: return (_quarter / 8) + (_quarter / 16);
		case NoteDivision.THIRTY_SECOND_TRIPLET: return (_quarter / 8) * (2 / 3);
		case NoteDivision.SIXTY_FOURTH: return _quarter / 16;
		case NoteDivision.SIXTY_FOURTH_DOTTED: return (_quarter / 16) + (_quarter / 32);
		case NoteDivision.SIXTY_FOURTH_TRIPLET: return (_quarter / 16) * (2 / 3);
	}
}

/// @desc Returns the length of an array of note divisions in seconds, given a bpm
/// @arg {Real} bpm
/// @arg {Array<Real>} note_divisions Array of "NoteDivision" enum
function mt_get_note_total_length(bpm, note_divisions) {
	var _total = 0;
	for (var i = 0; i < array_length(note_divisions); i++) {
		_total += mt_get_note_length(bpm, note_divisions[i]);
	}
	return _total;
}

/// @desc Get the note name for a given MIDI note number
/// @arg {Real} note_number MIDI note number (0-127)
function mt_note_from_number(note_number) {
	var _fixed_number = clamp(round(note_number), 0, 127);
	var _note = global._mt_constants.letters[_fixed_number % 12];
	var _octave = floor(_fixed_number / 12) - 1;
	return _note + string(_octave);
}

/// @desc Get the closest note information for a given frequency
/// @arg {Real} frequency Note frequency in hz
function mt_note_from_frequency(frequency) {
	var _value = (12 * (ln(frequency) - global._mt_constants.l440)) / global._mt_constants.l2 + 69;
	var _note_number = round(_value * 100) / 100;
	var _fixed_number = clamp(round(_note_number), 0, 127);
	
	return {
		midi: _fixed_number,
		note: mt_note_from_number(_fixed_number),
		frequency: mt_midi_note_frequency(_fixed_number)
	};
}