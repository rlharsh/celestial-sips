pxlui = new pxlui_create();

var _group1 = new pxlui_group("0","0",[
	new pxlui_button("100", "80","Continue", function() {
		room_goto(rm_game_new_save);	
	},{
		width: 96,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "90","New Game",,{
		width: 96,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "100","Load Game",,{
		width: 96,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "110","Options",,{
		width: 100,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "120","Credits",,{
		width: 96,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
		new pxlui_button("100", "130","Exit", function() {
			game_end(0);	
		},{
		width: 96,
		height: 20,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
],{width: display_get_gui_width(), height: display_get_gui_height(), halign: fa_center,valign: fa_center});

pxlui.add_page("DemoPage",[
	_group1,
]);

pxlui.load_page("DemoPage");
