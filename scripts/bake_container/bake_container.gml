globalvar baseContainer, hovering;

hovering = noone;

//overflow
#macro allow 0
#macro hidden 1

//background
#macro fill 0
#macro bgSurface 1
#macro bgSprite 2

enum pattern{
	repetition,
	stretch
}

//display
enum display{
	fixed,
	flex
}

//direction
enum dir{
	row,
	column,
	box,
	stack
}

baseContainer = {
	//general
	"width": 0,
	"height": 0,
	"direction": dir.row,
	"display": display.fixed,
	"offsetX": 0,
	"offsetY": 0,
	"parent": self,
	"offsetX": 0,
	"offsetY": 0,
	"contentOffsetX": 0,
	"contentOffsetY": 0,
	
	//background
	"backgroundPattern": pattern.repetition,
	"image_index": 0,
	"bgScale": 1,
	"bgType": fill,
	"background": c_white,
	"color": c_white,
	
	//text stuff
	"text": "",
	"textScale": 1,
	"font": -1,
	"fontSize": 0,
	"newline": true,
	"textColor": c_black,
	"fitText": false,
	"textAlpha": 1,
	
	//draw config
	"overflow": allow,
	"draw": true,
	"debug": false,
	"alignItems": fa_left,
	"justifyContent": fa_top,

	//children
	"content": [],
	
	//border radius
	"radiusTopLeft": 0,
	"radiusTopRight": 0,
	"radiusBottomLeft": 0,
	"radiusBottomRight": 0,
	
	//
	"paddingLeft": 0,
	"paddingRight": 0,
	"paddingTop": 0,
	"paddingBottom": 0,
	
	"marginLeft": 0,
	"marginRight": 0,
	"marginTop": 0,
	"marginBottom": 0,
	
	//variables you shouldnt define
	"baked": true,
	"surface": noone,
	"backgroundSurface": noone,
	"tx": 0,
	"ty": 0,
	"twidth": 0,
	"theight": 0,
	"wrapped": false,
	"bounds": {
		"x": -infinity,
		"y": -infinity,
		"x1": infinity,
		"y1": infinity,
	}
}

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