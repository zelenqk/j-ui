function draw_container(container, cx, cy){
	if (container[$ "baked"] == undefined) bake_container(container);
	if (!container.draw) return {"w": 0, "h": 0};
	
	//get current drawing config to reset when we're done
	var bColor = draw_get_color();
	var bAlpha = draw_get_alpha();
	var bFont = draw_get_font();
	
	cx += (container.marginLeft + container.offsetX);
	cy += (container.marginTop + container.offsetY);
	
	if (container.position == position.absolute){
		container.tx = container.parent.tx + (container.marginLeft + container.offsetX);	
		container.ty = container.parent.ty + (container.marginTop + container.offsetY);	
	}
	
	//prepare bools
	var upperSurface = surface_get_target();
	var overflowHidden = (container.parent.overflow == hidden);
	var wrapped = container.wrapped;
	
	var x1 = container.tx - container.paddingLeft * !wrapped;
	var y1 = container.ty - container.paddingTop * !wrapped;
	
	var x2 = x1 + container.width + container.paddingLeft + container.paddingRight;
	var y2 = y1 + container.height + container.paddingTop + container.paddingBottom;
	
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
	
	if (mir != noone){
		execute_script(container, "onHover");
		
		hovering = container;
	}
	
	if (hovering == container and mir == noone){
		hovering = noone;		
	}

	draw_background(container, cx, cy, upperSurface);
	
	cx += container.paddingLeft;
	cy += container.paddingTop;
	
	container.tx += container.paddingLeft;
	container.ty += container.paddingTop;
	
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
	var apply = (container.overflow == hidden);
	
	if (apply){
		container.surface = surface_target(container.surface);
		draw_clear_alpha(c_black, 0);
	}

	
	var subContainersN = array_length(container.content);

	var tx = container.contentOffsetX + align(container.alignItems, container.width, container.twidth);
	var ty = container.contentOffsetY + justify(container.justifyContent, container.height, container.theight);

	container.twidth = 0;
	container.theight = 0;
	
	draw_string(container, cx, cy);

	var twidth = 0;
	var theight = 0
	
	var startx = tx;
	var starty = ty;
	
	var next = {
		"w": 0,
		"h": 0,
	}
	
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
		
		switch (container.direction) {
		case dir.row:
			tx += next.w;
			twidth += next.w;
			theight = max(theight, next.h);
			break;
		case dir.column:
			ty += next.h;
			theight += next.h;
			twidth = max(twidth, next.w);
			break;
		case dir.box:
			tx += next.w;
			twidth = max(twidth, tx + next.w - startx);
			theight = max(theight, next.h);
			
			if (tx > container.width or tx < 0) {
				tx = startx * (tx > 0);
				ty += theight;
			}
			break;
		case dir.stack:
			ty += next.h;
			theight = max(theight, ty + next.h - starty);
			twidth = max(twidth, next.w);
			
			if (ty > container.height) {
				ty = starty;
				tx += twidth;
				twidth = next.w;
			}
			break;
		}
	}
	
	if (container.twidth < twidth) container.twidth = twidth;
	if (container.theight < theight) container.theight = theight;
	
	surface_reset_t();
	
	if (wrapped and container.position != position.absolute) {
		upperSurface = surface_target(upperSurface);
	}
	
	if (container.overflow == hidden){
		container.surface = surface_draw(container.surface, cx, cy);
		
		if (container.paddingLeft == 0 and container.paddingRight == 0 and container.paddingTop == 0 and container.paddingBottom == 0){
			gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
			draw_sprite_stretched(container.borderCookie, 0, cx, cy, container.width, container.height);
			gpu_set_blendmode(bm_normal);
		}
		
		if (wrapped and container.position != position.absolute) surface_reset_t();
	}
	
	if (wrapped){
		upperSurface = surface_target(upperSurface);
	}
	
	if (container.display == display.flex){
		container.width = container.twidth;	
		container.height = container.theight;	
	}
	
	execute_script(container, "step");

	if (hovering == container){
		execute_script(container, "onTrueHover");
		if (mouse_check_button_pressed(mb_any)) execute_script(container, "onClick");
	}
	
	draw_set_color(bColor);
	draw_set_alpha(bAlpha);
	draw_set_font(bFont);
	
	if (container.position == position.relative) return {"w": container.width + container.marginLeft + container.marginRight + container.paddingLeft + container.paddingRight, "h": container.height + container.marginTop + container.marginBottom + container.paddingTop + container.paddingBottom}
	else return {"w": 0, "h": 0}
}

function execute_script(container, name){
	if (is_method(container[$ name])) container[$ name]();
}

function mouse_in_rectangle(tx, ty, tx1, ty1){
	for(var i = 0; i < 10; i++){
		if (point_in_rectangle(device_mouse_x_to_gui(i), device_mouse_y_to_gui(i), tx, ty, tx1 - 1, ty1 - 1)) return i;	
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