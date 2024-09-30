function SimpleUI() constructor
{
    groups			= [];
	pages			= [];
	selected_page	= -1;
	
	static add_page = function(_page) {
		array_push(pages, _page);
	}
    
    static add_group = function(_group) {
        array_push(groups, _group);
    }
	
    static step = function() {
        if (array_length(pages) < 1 || selected_page = -1) return;
		
		live_name = "simple_ui:step";
		if (live_call()) return live_result;
		
		for (var _i = 0; _i < array_length(pages); _i++) {
			if (pages[_i].persist) {
				pages[_i].step();	
			}
		}
        
        pages[selected_page].step();
    }
    
    static draw = function() {
		live_name = "simple_ui:draw";
		if (live_call()) return live_result;
		
        if (array_length(pages) < 1 || selected_page = -1) return;

		for (var _i = 0; _i < array_length(pages); _i++) {
			if (pages[_i].persist) {
				pages[_i].draw();	
			}
		}
        
        pages[selected_page].draw();
    }
	
	static destroy = function() {
		if (array_length(pages) < 1 || selected_page = -1) return;
		
		pages[selected_page].destroy();
	}
	
	static set_page = function(_name) {
		for (var _i = 0; _i < array_length(pages); _i++) {
			if (pages[_i].name == _name) {
				selected_page = _i;
				return;
			}
		}
	}
}
