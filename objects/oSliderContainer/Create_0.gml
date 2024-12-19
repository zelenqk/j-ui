main = {
	"display": flex,
	"background": c_black,
	"direction": column,
	"alignItems": fa_center,
	"alpha": 0.25,
}

content = {
	"width": 300,
	"height": 120,
	"justifyContent": fa_center,
	"gap": 24,
	"overflow": hidden,
	"background": c_black,
	"alpha": 0.25
}

optionStyle = {
	"display": flex,
	"background": c_white,
	"textColor": c_black,
	"alpha": 1,
	"onHover": {
		"alpha": "-0.25", //setting the variable alpha as a string sets it as additive aka (draw_get_alpha() + real(alpha))
	},
	"onClick": function(){
		show_message("You chose " + string(text));
	},
}

var options = [
	{
		"text": "option 1",		
	},{
		"text": "option 2",		
	},{
		"text": "option 3",		
	},{
		"text": "option 4",		
	},{
		"text": "option 5",		
	}
]

content.content = copy_styles(optionStyle, options);

sliderWrapper = {
	"width": content.width,
	"height": 24,
	"background": c_black,
	"alpha": 0.75,
}

slider = {
	"width": 20,
	"height": sliderWrapper.height,
	"background": c_white,
	"alpha": 0.35,
	"textColor": c_black,
	"onHover": {
		"alpha": "-0.05",	
	},
	"onClick": function(){
		mxDelta = device_mouse_x_to_gui(0);
	},
	"onHold": function(){
		offsetx -= mxDelta - device_mouse_x_to_gui(0);
		offsetx = clamp(offsetx, 0, parent.width - width);
		
		var wScale = parent.width / width;
		var content = parent.parent.content[1];

		for(var i = 0; i < array_length(content.content); i++){
			var option = content.content[i];
			
			option.offsetx = -offsetx * wScale;
		}
		
		mxDelta = device_mouse_x_to_gui(0);
	},
	"step": function(){
		var content = parent.parent.content[1];

		var twidth = 0;
		for(var i = 0; i < array_length(content.content); i++){
			var option = content.content[i];
			
			twidth += option.width + content.gap;
		}
		
		var wScale = parent.width / twidth;
		width = wScale * parent.width;
	}
}

sliderWrapper.content = [slider];

main.content = [
	{
		"text": "Example slider container with hidden content",
		"textColor": c_white,
		"display": flex,
		"background": noone,
	},
	content,
	sliderWrapper,
]