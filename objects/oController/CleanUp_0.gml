//clean up any surfaces that might still be here

for(var i = 0; i < array_length(surfaceList); i++){
	surface_free(surfaceList[i]);
}