function DialogueSystem() constructor {
    dialogue_tree = {};
    current_dialogue = undefined;
    selected_option = -1;
    
    static start = function(start_key) {
        current_dialogue = variable_struct_get(dialogue_tree, start_key);
    }
    
    static step = function() {
        if (current_dialogue == undefined) return;
        
        if (current_dialogue.options != undefined) {
            var option_selected = get_selected_option();
            if (option_selected != -1) {
                var selected = current_dialogue.options[option_selected];
                if (selected.callback != undefined) {
                    selected.callback();
                }
                current_dialogue = variable_struct_get(dialogue_tree, selected.next);
                selected_option = -1;
            }
        } else if (keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) {
            if (current_dialogue.next != undefined) {
                current_dialogue = variable_struct_get(dialogue_tree, current_dialogue.next);
            }
        }
    }
    
    static draw = function() {
        if (current_dialogue == undefined) return;
        
        draw_text(10, 10, current_dialogue.text);
        
        if (current_dialogue.options != undefined) {
            for (var i = 0; i < array_length(current_dialogue.options); i++) {
                var option_text = current_dialogue.options[i].text;
                if (i == selected_option) {
                    option_text = "> " + option_text;
                }
                draw_text(10, 40 + i * 30, string(i + 1) + ". " + option_text);
            }
        }
    }
    
    static add_dialogue = function(key, dialogue) {
        variable_struct_set(dialogue_tree, key, dialogue);
    }
    
    static get_selected_option = function() {
        if (current_dialogue.options == undefined) return -1;
        
        if (input_check_pressed("left")) {
            selected_option = max(0, selected_option - 1);
        }
        if (input_check_pressed("right")) {
            selected_option = min(array_length(current_dialogue.options) - 1, selected_option + 1);
        }
        if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
            return selected_option;
        }
        return -1;
    }
}

function DialogueOption(_text, _next, _callback = undefined) constructor {
    text = _text;
    next = _next;
    callback = _callback;
}

function Dialogue(_text, _options = undefined, _next = undefined) constructor {
    text = _text;
    options = _options;
    next = _next;
}