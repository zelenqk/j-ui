globalvar baseContainer;

//overflow
#macro allow 0
#macro hidden 1

//background
#macro fill 0
#macro bgSurface 1
#macro bgSprite 2

enum pattern{
	repetition,
	stretch,
	leave
}	

//direction
enum dir{
	row,
	column,
	box,
	stack
}

baseContainer = {
	"width": 0,
	"height": 0,
	"background": c_white,
	"color": c_white,
	"bgType": fill,
	"overflow": allow,
	"draw": true,
	"drawContent": true,
	"repetitionH": 1,
	"repetitionV": 1,
	"direction": dir.row,
	"marginLeft": 0,
	"marginRight": 0,
	"marginTop": 0,
	"marginBottom": 0,
	"offsetX": 0,
	"offsetY": 0,
	"debug": false,
	"alignItems": fa_left,
	"twidth": 0,
	"theight": 0,
	"bounds": {
		"x1": -infinity,
		"y1": -infinity,
		"x2": infinity,
		"y2": infinity,
	},
	"backgroundPattern": 0,
	"tx": 0,
	"ty": 0,
	"paddingLeft": 0,
	"paddingRight": 0,
	"paddingTop": 0,
	"contentOffsetX": 0,
	"contentOffsetY": 0,
	"paddingBottom": 0,
	"image_index": 0,
	"bgScale": 0,
	"justifyContent": fa_top,
	"baked": true,
	"parent": self,
	"content": [],
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
			
		//repetition
		case "repetition":
			container.repetitionH = container.repetition;
			container.repetitionV = container.repetition;
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

function draw_container(container, cx, cy){
	if (container[$ "baked"] == undefined) bake_container(container);
	if (!container.draw) return{"x": 0, "y": 0};
	
	var bColor = draw_get_color();
	var bAlpha = draw_get_alpha();
	var bFont = draw_get_font();
	
	var upperSurface = surface_get_target();
	var overflowHidden = upperSurface != -1;
	var wrapped = overflowHidden;
	
	if (wrapped == false){
		container.bounds = {
			"x1": container.tx, 	
			"y1": container.ty, 
			"x2": container.tx + container.width, 	
			"y2": container.ty + container.height, 
		}
	}
	
	cx += container.marginLeft + container.offsetX;
	cy += container.marginTop + container.offsetY;

	if (!overflowHidden){
		container.tx = cx;
		container.ty = cy;
	}else{
		container.tx = container.parent.tx + cx;	
		container.ty = container.parent.ty + cy;	
	}
	
	var x1 = container.tx;
	var y1 = container.ty;

	var x2 = x1 + container.width;
	var y2 = y1 + container.height;
	
	if (overflowHidden and wrapped == false){
		x1 = max(x1, container.parent.tx - container.parent.marginLeft);
		y1 = max(y1, container.parent.ty - container.parent.marginTop);
		
		x2 = min(container.tx + container.width, container.parent.tx + container.parent.width + container.parent.marginRight);
		y2 = min(container.ty + container.height, container.parent.ty + container.parent.height + container.parent.marginBottom);
	}else if (overflowHidden and wrapped){
		//apply parent's parent bounds
		x1 = max(x1, container.parent.bounds.x1);
		y1 = max(y1, container.parent.bounds.y1);
		
		x2 = min(container.tx + container.width, container.parent.bounds.x2);
		y2 = min(container.ty + container.height, container.parent.bounds.y2);
	
		//now apply parent's bounds
		x1 = max(x1, container.parent.tx - container.parent.marginLeft);
		y1 = max(y1, container.parent.ty - container.parent.marginTop);
		
		x2 = min(x2, container.parent.tx + container.parent.width + container.parent.marginRight);
		y2 = min(y2, container.parent.ty + container.parent.height + container.parent.marginBottom);
	}
	
	var mir = mouse_in_rectangle(x1, y1, x2, y2);
	
	execute_script(container, "step");	
	if (mir != noone){
		execute_script(container, "onHover");	
	}
	
	switch (container.bgType){
	case fill:
		draw_set_color(container.color);
		draw_rectangle(cx - container.paddingLeft, cy - container.paddingTop, cx + container.paddingRight + container.width - 1, cy + container.paddingBottom + container.height - 1, false);
		break;
	case bgSurface:
		switch (container.backgroundPattern){
		default:
			container.background = surface_draw(container.background, cx - container.paddingLeft, cy - container.paddingTop, container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom)
			break;
		case pattern.repetition:
			if (container.bgScale == 0){
				var width = container.width / container.repetitionH;
				var height = container.height / container.repetitionV;
				
				var startx = cx;
				var starty = cy;
				
				for(var i = 0; i < container.repetitionH; i++){
					var col = i mod container.repetitionH;
					var row = i div container.repetitionH;
					
					var tx = (col * width) + startx;
					var ty = (row * height) + starty;
					
					container.background = surface_draw(container.background, tx, ty, width, height);
				}
			}else{
				var width = (container.bgScale * get_surface_width(container.background));
				var height = (container.bgScale * get_surface_height(container.background));
				
				// Calculate integer repetitions
				var repetitionH = ceil((container.width + container.paddingLeft + container.paddingRight) / width);
				var repetitionV = ceil((container.height + container.paddingTop + container.paddingBottom) / height);
				
				var startx = cx;
				var starty = cy;
				
				for (var i = 0; i < repetitionH * repetitionV; i++) {
					var col = i mod repetitionH;
					var row = i div repetitionH;
					
					var tx = (col * width) + startx;
					var ty = (row * height) + starty; 
					
					container.background = surface_draw(container.background, tx, ty, width, height);
				}
			}
			break;
		}
		break;
	case bgSprite:
		switch (container.backgroundPattern){
		default:
			draw_sprite_stretched(container.background, container.image_index, cx - container.paddingLeft, cy - container.paddingTop, container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom)
			break;
		case pattern.repetition:
			if (container.bgScale == 0){
				var width  = (container.width + container.paddingLeft + container.paddingRight) / container.repetitionH;
				var height = (container.height + container.paddingTop + container.paddingBottom) / container.repetitionV;
				
				var startx = cx;
				var starty = cy;
				
				for(var i = 0; i < container.repetitionH * container.repetitionV; i++){
					var col = i mod container.repetitionH;
					var row = i div container.repetitionH;
					
					var tx = (col * width) + startx;
					var ty = (row * height) + starty;
					
					draw_sprite_stretched(container.background, container.image_index, tx, ty, width, height);
				}
			}else{
				var width = (container.bgScale * sprite_get_width(container.background));
				var height = (container.bgScale * sprite_get_height(container.background));
				
				// Calculate integer repetitions
				var repetitionH = ceil((container.width + container.paddingLeft + container.paddingRight) / width);
				var repetitionV = ceil((container.height + container.paddingTop + container.paddingBottom) / height);
				
				var startx = cx;
				var starty = cy;
				
				for (var i = 0; i < repetitionH * repetitionV; i++) {
					var col = i mod repetitionH; // Column index
					var row = i div repetitionH; // Row index
					
					var tx = (col * width) + startx;
					var ty = (row * height) + starty; 
					
					draw_sprite_stretched(container.background, container.image_index, tx, ty, width, height);
				}
			}
			break;
		}
		break;
	}
	
	if (container.debug){
		var mir = mouse_in_rectangle(x1, y1, x2, y2);
		
		surface_reset_target();
		draw_set_color(c_green);
		draw_rectangle(x1, y1, x2, y2, mir == noone);	
		draw_set_color(bColor);
		upperSurface = surface_target(upperSurface)
	}
	
	//draw content
	var subContainersN = array_length(container.content) * container.drawContent;
	
	var tx = cx;
	var ty = cy;
	
	if (container.overflow == hidden){
		tx = 0;
		ty = 0;
		
		container.surface = surface_target(container.surface);
		draw_clear_alpha(c_black, 0);
	}
	
	tx += container.contentOffsetX;
	ty += container.contentOffsetY;
	
	switch (container.alignItems){
	case fa_center:
		tx += (container.width / 2 - container.twidth / 2);
		break;
	case fa_right:
		tx += (container.width - container.twidth);
		break;
	}
	
	switch (container.justifyContent){
	case fa_center:
		ty += (container.height / 2 - container.theight / 2);
		break;
	case fa_bottom:
		ty += (container.height - container.theight);
		break;
	}
	
	var startx = tx;
	var starty = ty;
	
	for(var i = 0; i < subContainersN; i++){
		var subContainer = container.content[i];
		subContainer.parent = container;
		
		if (container.overflow == hidden and wrapped = false) subContainer.bounds = container.bounds;
			
		var next = draw_container(subContainer, tx, ty);
		
		switch (container.direction){
		case dir.row:
			tx += next.x;
			
			if ((ty - starty) + next.y > container.theight) container.theight = (ty - starty) + next.y;
			if ((tx - startx) + next.x > container.twidth) container.twidth = (tx - startx) + next.x;
			break;
		case dir.column:
			ty += next.y;
		
			if ((ty - starty) + next.y > container.theight) container.theight = (ty - starty) + next.y;
			if ((tx - startx) + next.x > container.twidth) container.twidth = (tx - startx) + next.x;
			break;
		case dir.box:
			tx += next.x;
			
			if ((ty - starty) + next.y > container.theight) container.theight = (ty - starty) + next.y;
			if ((tx - startx) + next.x > container.twidth) container.twidth = (tx - startx) + next.x;
			
			if (tx >= container.width){
				tx = startx;
				ty += container.theight;
			}
			break;
		case dir.stack:
			ty += next.y;
			
			if ((ty - starty) + next.y > container.theight) container.theight = (ty - starty) + next.y;
			if ((tx - startx) + next.x > container.twidth) container.twidth = (tx - startx) + next.x;
			
			if (ty >= container.height){
				ty = starty;
				tx += container.twidth;
			}
			break;
		}
	}
	
	surface_reset_t();
	
	if (overflowHidden) upperSurface = surface_target(upperSurface);
 
	if (container.overflow == hidden) {
		container.surface = surface_draw(container.surface, cx, cy);	
		
		if (overflowHidden) surface_reset_t();
	}
	
	draw_set_color(bColor);
	draw_set_alpha(bAlpha);
	draw_set_font(bFont);
	
	return {"x": container.width + container.paddingLeft + container.paddingRight + container.marginLeft + container.marginRight, "y": container.height + container.paddingTop + container.paddingBottom + container.marginTop + container.marginBottom};
}

function execute_script(container, name){
	if (is_method(container[$ name])) container[$ name]();
}

function mouse_in_rectangle(tx, ty, tx1, ty1){
	for(var i = 0; i < 10; i++){
		if (point_in_rectangle(device_mouse_x_to_gui(i), device_mouse_y_to_gui(i), tx, ty, tx1, ty1)) return i;	
	}
	
	return noone;
}