function draw_string(container, cx, cy) {
	// Save drawing state
	var bColor = draw_get_color();
	var bAlpha = draw_get_alpha();
	var bFont = draw_get_font();
	
	// Ensure container properties are valid
	if (!is_string(container.text) || !is_real(container.textScale) || container.textScale <= 0) return;
	if (container.font != noone) draw_set_font(container.font);
	
	// Set text properties
	draw_set_color(container.textColor);
	draw_set_alpha(container.textAlpha);
	
	// Handle text scale and fitting
	var scale = container.textScale;
	if (container.fontSize != 0) scale = container.fontSize;
	
	var width = string_width(container.text) * scale;
	var height = string_height(container.text) * scale;
	
	if (container.newline && container.display != display.flex) {
		if (container.fitText) {
			height = string_height_ext(container.text, container.width / scale, container.width) * scale;
			scale = min(scale, container.height / height);
			height = string_height_ext(container.text, container.width / scale, container.width) * scale;
		}
		
		width = container.width;
	}

	// Align text within container
	var tx = cx + align(container.alignItems, container.width, width);
	var ty = cy + justify(container.justifyContent, container.height, height);
	
	// Draw the text
	draw_text_ext_transformed(tx, ty, container.text, scale, container.width, scale, scale, 0);
	
	// Restore drawing state
	draw_set_color(bColor);
	draw_set_alpha(bAlpha);
	draw_set_font(bFont);
}
