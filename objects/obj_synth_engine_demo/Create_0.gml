synth = synth_create(6);
synth_amp_envelope_adsr(synth, 0.01, 0, 1, 0.1);
synth_add_osc(synth, synth_waveform_sine);

current_waveform = 0;
waveform_names = ["sine", "saw", "square", "triangle"];

buffer_segments_to_draw = 3;
data_graph_x = 0;
data_graph_y = 0;
data_graph_width = 640 / buffer_segments_to_draw;
data_graph_height = 480;

keys = [
	{
		frequency: mt_note_frequency("C4"),
		note_index: -1,
		key: ord("A")
	},
	{
		frequency: mt_note_frequency("C#4"),
		note_index: -1,
		key: ord("W")
	},
	{
		frequency: mt_note_frequency("D4"),
		note_index: -1,
		key: ord("S")
	},
	{
		frequency: mt_note_frequency("D#4"),
		note_index: -1,
		key: ord("E")
	},
	{
		frequency: mt_note_frequency("E4"),
		note_index: -1,
		key: ord("D")
	},
	{
		frequency: mt_note_frequency("F4"),
		note_index: -1,
		key: ord("F")
	},
	{
		frequency: mt_note_frequency("F#4"),
		note_index: -1,
		key: ord("T")
	},
	{
		frequency: mt_note_frequency("G4"),
		note_index: -1,
		key: ord("G")
	},
	{
		frequency: mt_note_frequency("G#4"),
		note_index: -1,
		key: ord("Y")
	},
	{
		frequency: mt_note_frequency("A4"),
		note_index: -1,
		key: ord("H")
	},
	{
		frequency: mt_note_frequency("A#4"),
		note_index: -1,
		key: ord("U")
	},
	{
		frequency: mt_note_frequency("B4"),
		note_index: -1,
		key: ord("J")
	},
	{
		frequency: mt_note_frequency("C5"),
		note_index: -1,
		key: ord("K")
	},
	{
		frequency: mt_note_frequency("D5"),
		note_index: -1,
		key: ord("L")
	}
];