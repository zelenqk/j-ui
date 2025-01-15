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
			
		//border radius stuff
		case "borderRadius":
			container.radiusTopLeft = container.borderRadius;
			container.radiusBottomLeft = container.borderRadius;
			container.radiusTopRight = container.borderRadius;
			container.radiusBottomRight = container.borderRadius;
			break;
		case "radiusLeft":
			container.radiusTopLeft = container.radiusLeft;
			container.radiusBottomLeft = container.radiusLeft;
			break;
		case "radiusRight":
			container.radiusTopRight = container.radiusRight;
			container.radiusBottomRight = container.radiusRight;
			break;
		case "radiusTop":
			container.radiusTopRight = container.radiusTop;
			container.radiusTopLeft = container.radiusTop;
			break;
		case "radiusBottom":
			container.radiusBottomRight = container.radiusBottom;
			container.radiusBottomLeft = container.radiusBottom;
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
	container.backgroundSurface = create_surface(container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom);
	container.borderCookie = rounded_rectangle(container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom, container.radiusTopLeft, container.radiusTopRight, container.radiusBottomLeft, container.radiusBottomRight, c_black);
	container.baked = true;
}