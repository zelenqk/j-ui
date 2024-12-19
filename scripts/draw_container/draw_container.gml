globalvar baseContainer, baseContainerNames;

//position
#macro relative 0
#macro absolute 1

//display
#macro fixed 0
#macro flex 1

//overflow
#macro hidden 0
#macro allow 1
#macro fit 3

//direction
#macro row 0
#macro column 1
#macro box 2
#macro reverse_row -1
#macro reverse_column -2

baseContainer = {
	"color": c_black,
	"alpha": 1,
	"font": -1,
	"textAlpha": 1,
	"textColor": c_black,
	"hscale": 1,
	"vscale": 1,
	"scale": 1,
	"border": 0,
	"draw": true,
	"text": "",
	"halign": fa_left,
	"valign": fa_top,
	"padding": 0,
	"margin": 0,
	"hmargin": 0,
	"vmargin": 0,
	"margintop": 0,
	"marginbottom": 0,
	"marginright": 0,
	"marginleft": 0,
	"gap": 0,
	"baked": true,
	"background": c_white,
	"alignItems": fa_left,
	"justifyContent": fa_top,
	"parent": self,
	"content": [],
	"direction": row,
	"overflow": allow,
	"display": fixed,
	"width": 0,
	"offsetx": 0,
	"offsety": 0,
	"height": 0,
	"depth": 0,
	"twidth": 0,
	"theight": 0,
	"fontSize": 24,
	"position": relative,
	"drawContent": true,
}

baseContainerNames = variable_struct_get_names(baseContainer);

function bake_container(container, parent){
	
	for(var i = 0; i < array_length(baseContainerNames); i++){
		var name = baseContainerNames[i];
		
		if (container[$ name] == undefined) container[$ name] = baseContainer[$ name];
		else{
			switch (name){
			case "margin":
				container.margintop = container.margin;
				container.marginbottom = container.margin;
				container.marginright = container.margin;
				container.marginleft = container.margin;
				break;
			case "hmargin":
				container.marginright = container.hmargin;
				container.marginleft = container.hmargin;
				break;
			case "vmargin":
				container.margintop = container.vmargin;
				container.marginbottom = container.vmargin;
				break;
			default:
				break;
			}
		}
	}
	
	container.parent = parent;
	
	if (container.overflow == hidden){
		container.surface = create_surface(container.width, container.height);	
	}
	
	container.baked = true;
}

function draw_container(container, tx = 0, ty = 0, parent = baseContainer){
	if (container[$ "draw"] == false) return {"w": 0, "h": 0};
	if (container[$ "baked"] != true) {bake_container(container, parent); return {"w": 0, "h": 0};}
	
	tx += container.offsetx + container.marginleft;
	ty += container.offsety + container.margintop;
	
	var col = draw_get_color();
	var a = draw_get_alpha();
	var fnt = draw_get_font();
	
	draw_set_color(container.color);
	draw_set_alpha(container.alpha);
	draw_set_font(container.font);
	
	var upperSurf = surface_get_target();

	//events
	try{
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		
		var overflow = (upperSurf != -1);
		
		var x1 = container.x + container.offsetx;
		var y1 = container.y + container.offsety;
		var x2 = container.x + container.offsetx + container.width;
		var y2 = container.y + container.offsety + container.height;
		
		if (overflow){
			x2 = x1 + min(tx + container.width, surface_get_width(upperSurf)) - tx;
			y2 = y1 + min(ty + container.height, surface_get_height(upperSurf)) - ty;
		}else{
			x1 = tx;
			y1 = ty;
			x2 = x1 + container.width;
			y2 = y1 + container.height;
		}
		
		var pir = point_in_rectangle(mx, my, x1, y1, x2, y2);
		
		if (pir) execute_event(container, "onHover");
		if (mouse_check_button_pressed(mb_left) and pir) execute_event(container, "onClick");
		if (mouse_check_button_released(mb_left) and pir) execute_event(container, "onRelease");
		if (mouse_check_button(mb_left) and pir) execute_event(container, "onHold");
		if (!pir) execute_event(container, "otherwise");
		execute_event(container, "step");
	}catch(e){
		show_debug_message(e);
	}
	
	var bgType = (surface_exists(container.background) and container.background != c_black) * 1 + sprite_exists(container.background) * 2 + (container.background == noone) * 3;

	switch (bgType){
	case 0:	//its a color
		var bcol = draw_get_color();
		draw_set_color(container.background);
		draw_rectangle(tx - container.border, ty - container.border, tx + container.width - 1 + container.border, ty + container.height - 1 + container.border, false);
		draw_set_color(bcol);
		break;
	case 1:	//its a surface
		draw_surface_stretched_ext(container.background, tx, ty, tx + container.width, ty + container.height, container.background, container.alpha);
		break;
	case 2: //its a sprite
		draw_sprite_stretched_ext(container.background, 0, tx, ty, tx + container.width, ty + container.height, container.background, container.alpha);
		break;
	}
	
	draw_set_color(container.color);
	
	container.tx = tx;
	container.ty = ty;
	
	if (container.overflow == hidden){
		draw_set_alpha(1);
		container.surface = surface_draw(container.surface, tx, ty, container.width, container.height);
		draw_set_alpha(container.alpha);
		
		container.surface = surface_set_target(container.surface);
		
		draw_clear_alpha(c_black, 0);
	
		container.tx = 0;
		container.ty = 0;	
	}

	container.twidth = 0;
	container.theight = 0;
	
	for (var i = 0; i < array_length(container.content) * container.drawContent; i++) {
		var subContainer = container.content[i];
		
		var tx_ = 0;
		if (subContainer[$ "width"] != undefined and subContainer[$ "alignItems"] != undefined){
			var centerx = (container.width / 2 - subContainer.width / 2);
			var rightx = (container.width - subContainer.width);
			
			switch (container.alignItems){
			case fa_center:
				tx_ = centerx;
				break;
			case fa_right:
				tx_ = rightx;
				break;
			}
		}
		
		var ty_ = 0;

		if (subContainer[$ "height"] != undefined and subContainer[$ "justifyContent"] != undefined){
			var centery = (container.height / 2 - subContainer.height / 2);
			var bottomy = (container.height - subContainer.height);
			
			switch (container.justifyContent){
			case fa_center:
				ty_ = centery;
				break;
			case fa_bottom:
				ty_ = bottomy;
				break;
			}
		}
		
		subContainer.x = tx + container.tx + tx_ + container.gap / 2;
		subContainer.y = ty + container.ty + ty_ + container.gap / 2;
		
		var size = draw_container(subContainer, container.tx + tx_ + container.gap / 2, container.ty + ty_+ container.gap / 2, container);
		
		size.w += container.gap;
		size.h += container.gap;
		
		// Update position based on direction
		container.tx += size.w * (container.direction == row);
		container.ty += size.h * (container.direction == column);
		
		// Update target width and height
		if (container.direction == row) {
			// Width accumulates, height takes the max value
			container.twidth += size.w;
			container.theight = max(container.theight, size.h);
		} else if (container.direction == column) {
			// Height accumulates, width takes the max value
			container.theight += size.h;
			container.twidth = max(container.twidth, size.w);
		} else {
			// Handle other directions, such as box or reverse layouts
			container.twidth = max(container.twidth, size.w);
			container.theight = max(container.theight, size.h);
		}
	}
	
	var hscale = (container.width + container.padding * 2) / string_width(container.text);
	var vscale = (container.height + container.padding * 2) / string_height(container.text);
	
	var scale = (container.fontSize <= 0) ? (min(hscale, vscale)) : ((container.fontSize) / string_height(container.text));

	var textTx = tx + container.padding + (
	    ((container.width - container.padding * 2) / 2 - (string_width(container.text) * scale) / 2) * (container.halign == fa_center) + 
	    ((container.width - container.padding - string_width(container.text) * scale) * (container.halign == fa_right))
	);
	
	var textTy = ty + container.padding + (
	    ((container.height - container.padding * 2) / 2 - (string_height(container.text) * scale) / 2) * (container.valign == fa_center) + 
	    ((container.height - container.padding - string_height(container.text) * scale) * (container.valign == fa_bottom))
	);

	draw_set_alpha(container.textAlpha);
	draw_set_color(container.textColor);
	draw_text_ext_transformed_color(textTx, textTy, container.text, string_height(container.text) * scale, container.width / scale - container.padding, scale, scale, 0, draw_get_color(), draw_get_color(), draw_get_color(), draw_get_color(), container.textAlpha);
	
	if (container.twidth < (string_width(container.text) * scale) + container.padding * 2) {
		container.twidth = (string_width(container.text) * scale) + container.padding * 2;
	}
	
	if (container.theight < (string_height(container.text) * scale) + container.padding * 2) {
	    container.theight = (string_height(container.text) * scale) + container.padding * 2;
	}
	if (container.display == flex){
		container.width = container.twidth;
		container.height = container.theight;
	}
	
	surface_reset_t();
	
	if (upperSurf != -1) upperSurf = surface_target(upperSurf)
	
	draw_set_color(col);
	draw_set_alpha(a);
	draw_set_font(fnt);
	
	container.x = tx;
	container.y = ty;
	
	return {
		"w": (container.width + container.marginright + container.marginleft + container.border * 2) * (container.position == relative), 
		"h": (container.height + container.margintop + container.marginbottom + container.border * 2) * (container.position == relative),};
}

function execute_event(container, event){
	if (container[$ event] != undefined){
		var event_ = container[$ event];
		
		if (is_method(event_)) event_();
		else if (is_array(event_)) event_[0](event_);
		else{
			if (event_[$ "alpha"] != undefined){
				var alpha = event_[$ "alpha"];
				
				alpha = (is_string(alpha) ? draw_get_alpha() + real(alpha) : alpha);
				draw_set_alpha(alpha);
			}
			
			if (event_[$ "color"] != undefined) draw_set_color(event_[$ "color"]);
			
			if is_method(event_[$ "execute"]) event_[$ "execute"]();
			else if (is_array(event_[$ "execute"])) event_[$ "execute"][0](event_[$ "execute"]);
		}
	}
}