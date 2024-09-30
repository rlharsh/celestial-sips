function configuration_manager_show_options(){
	if (instance_exists(obj_controller_configuration)) {
		global.configuration_showing = true;
	}
}

function configuration_manager_hide_options(){
	if (instance_exists(obj_controller_configuration)) {
		global.configuration_showing = false;
	}
}