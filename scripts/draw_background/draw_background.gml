function draw_background(container, cx, cy){
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
}