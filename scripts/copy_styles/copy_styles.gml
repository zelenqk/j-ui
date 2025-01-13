function copy_styles(mainStyle, array){
	var names = variable_struct_get_names(mainStyle);
	
	for(var i = 0; i < array_length(array); i++){
		var container = array[i];
		
		for(var u = 0; u < array_length(names); u++){
			var name = names[u];
			
			if (container[$ name] == undefined){
				if (is_method(mainStyle[$ name])) container[$ name] = method(container, mainStyle[$ name]);
				else container[$ name] = mainStyle[$ name];
			}
		}
	}
	
	return array;
}

function copy_styles_array(mainStyle, number){
	var array = array_create(number, {});
	
	for(var i = 0; i < array_length(array); i++){
		array[i] = struct_copy(mainStyle);
	}
	
	return array;
}



function struct_copy(struct){
    var structNames = variable_struct_get_names(struct);
    
    var newStruct = {};
    for (var i = 0; i < array_length(structNames); i++;){
		var name = structNames[i];
		
		if (is_method(struct[$ name])) newStruct[$ name] = method(newStruct, struct[$ name]);
		else newStruct[$ name] = struct[$ name]
	}
    
    return newStruct;
}

