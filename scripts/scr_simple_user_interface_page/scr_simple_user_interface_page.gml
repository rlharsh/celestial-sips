function SimplePage(_name) constructor {
	name	= _name;
	groups	= [];
	
	static add_group = function(_group) {
		array_push(groups, _group);	
	}
	
	static step = function() {
		if (array_length(groups) < 1) return;
		
		for (var _i = 0; _i < array_length(groups); _i++) {
			groups[_i].step();
		}
	}
	
	static draw = function() {
		if (array_length(groups) < 1) return;
		
		for (var _i = 0; _i < array_length(groups); _i++) {
			groups[_i].draw();
		}
	}
	
	static destroy = function() {
		if (array_length(groups) < 1) return;
		
		for (var _i = 0; _i < array_length(groups); _i++) {
			groups[_i].destroy();
		}
	}
}