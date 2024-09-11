if (is_undefined(data)) exit;

if (audio_is_playing(data.audio_play_index)) audio_stop_sound(data.audio_play_index);
audio_free_play_queue(data.queue);
for (var i = 0; i < synth_max_audio_buffers; i++) {
	buffer_delete(data.buffers[i]);
}