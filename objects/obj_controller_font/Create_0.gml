initialized = false;
default_font = undefined;

fonts_database = [
	{
		name:			"Carton",
		asset:			spr_carton,
		attribution:	"https://damieng.com/typography/zx-origins/carton/",
		separation:		2,
		font_ref:		-1,
		font_default:	true
	}
];

array_foreach(fonts_database, function(_font) {
	try {
		_font.font_ref = font_add_sprite_ext(_font.asset, " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 1, _font.separation);
		if (_font.font_default) set_font(_font.name);
	} catch (_e) {
		show_message(_e);
	}
});

initialized = true;