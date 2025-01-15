function draw_background(container, cx, cy, upperSurface){
	if (upperSurface != -1) surface_reset_t();
	
	container.backgroundSurface = surface_target(container.backgroundSurface);
	draw_clear_alpha(c_black, 0);
	
	switch (container.bgType){
	case fill:
		draw_set_color(container.color);
		draw_rectangle(0, 0, container.paddingRight + container.paddingLeft + container.width - 1, container.paddingBottom + container.paddingTop + container.height - 1, false);
		break;
	case bgSurface:
		switch (container.backgroundPattern){
		default:
			container.background = surface_draw(container.background, 0, 0, container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom)
			break;
		case pattern.repetition:
			if (container.bgScale == 0){
				var width = container.width / container.repetitionH;
				var height = container.height / container.repetitionV;
				
				var startx = 0;
				var starty = 0;
				
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
				
				var startx = 0;
				var starty = 0;
				
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
			draw_sprite_stretched(container.background, container.image_index, 0, 0, container.width + container.paddingLeft + container.paddingRight, container.height + container.paddingTop + container.paddingBottom)
			break;
		case pattern.repetition:
			if (container.bgScale == 0){
				var width  = (container.width + container.paddingLeft + container.paddingRight) / container.repetitionH;
				var height = (container.height + container.paddingTop + container.paddingBottom) / container.repetitionV;
				
				var startx = 0;
				var starty = 0;
				
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
				
				var startx = 0;
				var starty = 0;
				
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
	
	surface_reset_t();
	
	if (upperSurface != -1) {
		upperSurface = surface_target(upperSurface)
	}
	
	container.backgroundSurface = surface_draw(container.backgroundSurface, cx, cy);

	gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
	draw_sprite(container.borderCookie, 0, cx, cy);
	gpu_set_blendmode(bm_normal);
}