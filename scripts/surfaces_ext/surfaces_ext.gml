globalvar surfaceList, surfaceData;
surfaceList = [];
surfaceData = [];

function create_surface(w, h, format = surface_rgba8unorm){
	if (w <= 0 or h <= 0) return noone;
	
	var surface = surface_create(w, h, format);
	var index = array_length(surfaceList);
	
	surfaceList[index] = surface;
	surfaceData[surface] = {
		"w": w,
		"h": h,
		"format": format,
		"index": index,
	}
	
	return surfaceList[index];
}

function surface_target(surface){
	if (!surface_exists(surface) and window_has_focus()) surface = resurface(surface);
	
	if (surface_exists(surface)) {
		surface_set_target(surface);

	}
	
	return surface;
}

function surface_reset_t(){
	if (surface_get_target() > -1) surface_reset_target();
}

function resurface(surface){
	show_debug_message("hui")
	if (surface < 0) return;
	
	var surfaceInfo = surfaceData[surface];
	surface_free(surface);
	
	surface = surface_create(surfaceInfo.w, surfaceInfo.h, surfaceInfo.format);
	
	surfaceData[surface] = surfaceInfo;
	surfaceList[surfaceInfo.index] = surface;
	
	return surface;
}

function surface_draw(surface, tx, ty, w = -1, h = -1){
	if (!surface_exists(surface) and window_has_focus()) surface = resurface(surface);
	
	if (w = -1) w = surface_get_width(surface);
	if (h = -1) h = surface_get_height(surface);
	
	if (surface_exists(surface)) draw_surface_stretched(surface, tx, ty, w, h);
	
	return surface;
}

function surface_purge(){
	for(var i = 0; i < array_length(surfaceList); i++){
		var surface = surfaceList[i];
		
		if (surface_exists(surface)) surface_free(surface);
	}	
}

function resize_surface(surface, w, h){
	if (!surface_exists(surface) and window_has_focus()) surface = resurface(surface);
	
	surfaceData[surface].w = w;
	surfaceData[surface].h = h;
	surface_resize(surface, w, h);
	
	return surface;
}

function get_surface_width(surface){
	if (surface_exists(surface)) return surfaceData[surface].w;
	
	return 0;
}

function get_surface_height(surface){
	if (surface_exists(surface)) return surfaceData[surface].h;
	
	return 0;
}

function free_surface(surface){
	var info = surfaceData[surface];
	array_delete(surfaceList, info.index, 1);
	array_delete(surfaceData, surface, 1);
	
	surface_free(surface);
}