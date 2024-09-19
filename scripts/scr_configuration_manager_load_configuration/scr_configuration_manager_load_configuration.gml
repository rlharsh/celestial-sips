function configuration_manager_load_configuration(_file){
	try {
		var _config_file	= file_text_open_read(_file);
		var _json_string	= "";
		
		while (!file_text_eof(_config_file)) {
			_json_string += file_text_read_string(_config_file) + "\n";
			file_text_readln(_config_file);
		}
		
		file_text_close(_config_file);
		
		var _json_data	= json_parse(_json_string);
		
		if (_json_data != -1) {
			return _json_data;	
		} else {
			show_debug_message("Error parsing JSON: Invalid JSON format.");
			return {};
		}
	} catch (_e) {
		show_debug_message(_e);
		return {};
	}
}