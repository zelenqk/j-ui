function bake_container(container){
	var names = variable_struct_get_names(baseContainer);
	var namesN = array_length(names);
	
	var unbaked = variable_struct_get_names(container);
	var unbakedN = array_length(unbaked);
	
	for(var i = 0; i < unbakedN; i++){
		var name = unbaked[i];
		
		switch (name){
			
		//margin stuff
		case "margin":
			container.marginLeft = container.margin;
			container.marginRight = container.margin;
			container.marginTop = container.margin;
			container.marginBottom = container.margin;
			break;
		case "marginH":
			container.marginLeft = container.marginH;
			container.marginRight = container.marginH;
			break;
		case "marginV":
			container.marginTop = container.marginV;
			container.marginBottom = container.marginV;
			break;
			
		//padding stuff
		case "padding":
			container.paddingLeft = container.padding;
			container.paddingRight = container.padding;
			container.paddingTop = container.padding;
			container.paddingBottom = container.padding;
			break;
		case "paddingH":
			container.paddingLeft = container.paddingH;
			container.paddingRight = container.paddingH;
			break;
		case "paddingV":
			container.paddingTop = container.paddingV;
			container.paddingBottom = container.paddingV;
			break;
		}
	}
	
	for(var i = 0; i < namesN; i++){
		var name = names[i];
		
		if (container[$ name] == undefined) container[$ name] = baseContainer[$ name];
	}
	
	if (container.overflow == hidden) container.surface = create_surface(container.width, container.height);
	container.baked = true;
}