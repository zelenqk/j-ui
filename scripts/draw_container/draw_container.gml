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
	"bgType": fill,
	"background": c_white,
	"color": c_white,
	"direction": dir.row,
	"display": display.fixed,
	"offsetX": 0,
	"offsetY": 0,
	"parent": self,
	"backgroundPattern": pattern.repetition,
	"bgScale": 1,
	"image_index": 0,
	"contentOffsetX": 0,
	"contentOffsetY": 0,
	
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

function draw_container(container, cx, cy){
	if (container[$ "baked"] == undefined) bake_container(container);
	if (!container.draw) return {"w": 0, "h": 0};
	
	//get current drawing config to reset when we're done
	var bColor = draw_get_color();
	var bAlpha = draw_get_alpha();
	var bFont = draw_get_font();
	
	cx += (container.marginLeft + container.offsetX);
	cy += (container.marginTop + container.offsetY);
	
	//prepare bools
	var upperSurface = surface_get_target();
	var overflowHidden = (container.parent.overflow == hidden);
	var wrapped = container.wrapped;
	
	var x1 = container.tx;
	var y1 = container.ty;
	
	var x2 = x1 + container.width;
	var y2 = y1 + container.height;
	
	if (overflowHidden){
		x1 = max(x1, container.parent.tx);	
		y1 = max(y1, container.parent.ty);
		
		x2 = min(x2, container.parent.tx + container.parent.width);
		y2 = min(y2, container.parent.ty + container.parent.height);
	}
	
	if (wrapped){
		x1 = max(x1, container.bounds.x1);	
		y1 = max(y1, container.bounds.y1);
		
		x2 = min(x2, container.bounds.x2);
		y2 = min(y2, container.bounds.y2);
	}
	
	var mir = mouse_in_rectangle(x1, y1, x2, y2);
	
	execute_script(container, "step");

	if (mir != noone){
		execute_script(container, "onHover")	
	}

	draw_background(container, cx, cy, upperSurface);
	
	cx += container.paddingLeft;
	cy += container.paddingTop;
	
	if (!overflowHidden and !wrapped){
		container.bounds = {
			"x1": cx,
			"y1": cy,
			"x2": cx + container.width,
			"y2": cy + container.height,
		}
		
		container.tx = cx;
		container.ty = cy;
	}
	//draw content
	var subContainersN = array_length(container.content);

	var tx = container.contentOffsetX + align(container.alignItems, container.width, container.twidth);
	var ty = container.contentOffsetY + justify(container.justifyContent, container.height, container.theight);
	
	var apply = (container.overflow == hidden);
		
	if (apply){
		container.surface = surface_target(container.surface);
		draw_clear_alpha(c_black, 0);
	}
	
	var twidth = 0;
	var theight = 0;
	
	for(var i = 0; i < subContainersN; i++){
		var subContainer = container.content[i];
		subContainer.parent = container;
		
		if (apply or wrapped){
			subContainer.wrapped = true;
			subContainer.bounds = container.bounds;
		}
		
		subContainer.tx = container.tx + tx;
		subContainer.ty = container.ty + ty;
		
		var next = draw_container(subContainer, cx * !apply + tx, cy * !apply + ty);
		
		switch (container.direction){
		case dir.row:
			tx += next.w;
			twidth += next.w;
			
			if (theight < next.h) theight = next.h;
			break;
		case dir.column:
			ty += next.h;
			theight += next.h;
			
			if (twidth < next.w) twidth = next.w;
			break;
		}
	}
	
	if (container.twidth < twidth) container.twidth = twidth;
	if (container.theight < theight) container.theight = theight;
	
	surface_reset_t();
	
	if (wrapped) upperSurface = surface_target(upperSurface);

	if (container.overflow == hidden){
		container.surface = surface_draw(container.surface, cx, cy);
		
		gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
		draw_sprite_stretched(container.borderCookie, 0, cx, cy, container.width, container.height);
		gpu_set_blendmode(bm_normal);
		
		if (wrapped) surface_reset_t();
	}
	
	if (container.display = display.flex){
		container.width = container.twidth;	
		container.height = container.theight;	
	}
	
	draw_set_color(bColor);
	draw_set_alpha(bAlpha);
	draw_set_font(bFont);
	
	return {"w": container.width + container.marginLeft + container.marginRight + container.paddingLeft + container.paddingRight, "h": container.height + container.marginTop + container.marginBottom + container.paddingTop + container.paddingBottom}
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

function justify(justifyContent, height, theight){
	switch (justifyContent){
	case fa_center:
		return (height / 2 - theight / 2);
		break;
	case fa_bottom:
		return (height - theight);
		break;
	}
	
	return 0;
}

function align(alignItems, width, twidth){
	switch (alignItems){
	case fa_center:
		return (width / 2 - twidth / 2);
		break;
	case fa_right:
		return (width - twidth);
		break;
	}
	
	return 0;
}