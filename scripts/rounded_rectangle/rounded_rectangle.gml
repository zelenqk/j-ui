vertex_format_begin();
vertex_format_add_position();
vertex_format_add_color();
global.vertex_format = vertex_format_end();

function rounded_rectangle(w, h, r1, r2, r3, r4, color) {
	var x1 = 0;
	var y1 = 0;
	var x2 = w;
	var y2 = h;

	// Ensure radii don't exceed half the width or height
	var rw = abs(x2 - x1) * 0.5;
	var rh = abs(y2 - y1) * 0.5;
	r1 = min(r1, rw, rh);
	r2 = min(r2, rw, rh);
	r3 = min(r3, rw, rh);
	r4 = min(r4, rw, rh);

	// Create vertex buffer
	var vb = vertex_create_buffer();
	vertex_begin(vb, global.vertex_format);

	// Number of segments for rounded corners
	var segments = 16;

	// Helper to add vertices
	function add_vertex(vb, color, tx, ty) {
		vertex_position(vb, tx, ty);
		vertex_color(vb, color, 1);
	}

	// Define corner centers and radii
	var corners = [
		[x1 + r1, y1 + r1, r1], // Top-left
		[x2 - r2, y1 + r2, r2], // Top-right
		[x2 - r3, y2 - r3, r3], // Bottom-right
		[x1 + r4, y2 - r4, r4]  // Bottom-left
	];

	// Angles for each corner
	var start_angles = [180, 270, 0, 90];

	// Generate vertices for corners
	for (var i = 0; i < 4; i++) {
		var cx = corners[i][0];
		var cy = corners[i][1];
		var radius = corners[i][2];
		var start_angle = start_angles[i];
		var end_angle = start_angle + 90;

		// Generate points along the arc
		for (var j = 0; j <= segments; j++) {
			var t = j / segments; // Normalize (0 to 1)
			var angle = degtorad(lerp(start_angle, end_angle, t)); // Interpolated angle
			add_vertex(vb, color, cx + cos(angle) * radius, cy + sin(angle) * radius);
		}
	}

	// Close the shape properly by linking to the first corner's start
	add_vertex(vb, color, corners[0][0], corners[0][1] - r1);

	vertex_end(vb);

	// Create the surface
	var surface = surface_create(w, h);
	surface_set_target(surface);

	draw_clear_alpha(0, 0); // Clear the surface with transparency
	vertex_submit(vb, pr_trianglefan, -1);

	surface_reset_target();
	vertex_delete_buffer(vb);

	var sprite = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
	surface_free(surface);

	return sprite;
}
