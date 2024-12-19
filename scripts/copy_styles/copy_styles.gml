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