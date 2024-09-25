function configuration_manager_show_options(){
	if (instance_exists(obj_controller_configuration)) {
		obj_controller_configuration.configuration_manager.configuration_showing = true;
	}
}

function configuration_manager_hide_options(){
	if (instance_exists(obj_controller_configuration)) {
		obj_controller_configuration.configuration_manager.configuration_showing = false;
	}
}