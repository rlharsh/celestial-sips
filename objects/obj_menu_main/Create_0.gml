pxlui = new pxlui_create();

var _group1 = new pxlui_group("0","0",[
	new pxlui_button("100", "80","Continue", function() {
		room_goto(rm_game_new_save);	
	},{
		width: 96,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		sprite_index: spr_button_bone_white,
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "91","New Game",,{
		width: 96,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		sprite_index: spr_button_bone_white,
		hover_index: 1,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "102","Load Game",,{
		width: 96,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		sprite_index: spr_button_bone_white,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "113","Options",,{
		width: 100,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		sprite_index: spr_button_bone_white,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("100", "124","Credits",,{
		width: 96,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		hover_index: 1,
		sprite_index: spr_button_bone_white,
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
		new pxlui_button("100", "135","Exit", function() {
			game_end(0);	
		},{
		width: 96,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		sprite_index: spr_button_bone_white,
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
