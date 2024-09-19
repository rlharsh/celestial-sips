controllers = [{
	controller:				obj_controller_gui,
	controller_ref:			-1,
	controller_initialized:	false,
}, {
	controller:				obj_controller_font,
	controller_ref:			-1,
	controller_initialized:	false,
}, {
	controller:				obj_controller_configuration,
	controller_ref:			-1,
	controller_initialized:	false,
}];

array_foreach(controllers, function(_controller) {
	try {
		_controller.controller_ref			= instance_create_layer(0, 0, "Controllers", _controller.controller);
		_controller.controller_initialized	= true;
	} catch (_e) {
		show_debug_message(_e);
	}
});

room_goto(rm_menu);