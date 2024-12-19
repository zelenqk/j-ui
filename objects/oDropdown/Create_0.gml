dropdownButton = {
	"text": "Hover over me",
	"font": fntMain,
	"display": flex,
	"fontSize": 32,
	"padding": 4,
	"textColor": c_white,
	"background": c_black,
	"alpha": 0.75,
	"onHover": function(){
		var dropdown = parent.content[2];
		dropdown.draw = true;
	},
	"otherwise": function(){
		var dropdown = parent.content[2];
		dropdown.draw = dropdown.draw and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), dropdown.x, dropdown.y, dropdown.x + dropdown.width, dropdown.y + dropdown.height);
	}
}

dropdownContainer = {
	"draw": false,
	"display": flex,
	"direction": column,
	"background": noone,
	"position": absolute //set position to absolute so it wont extend the container's width and height
}

buttonStyle = {
	"background": c_black,
	"display": flex,
	"fontSize": 32,
	"font": fntMain,
	"textColor": c_white,
	"padding": 6,
	"onHover": {
		"alpha": "-0.25",
	},
	"onClick": function(){
		show_message("You chose " + string(text));
	}
}

var options = [
	{
		"text": "option 1"
	},{
		"text": "option 2"
	},{
		"text": "option 3"
	}
]

dropdownContainer.content = copy_styles(buttonStyle, options);

example = {
	"border": 4,
	"background": c_black,
	"display": flex,
	"direction": column,
	"alpha": 0.4,
	"content": [
	{
		"display": flex,
		"background": noone,
		"fontSize": 24,
		"font": fntMain,
		"text": "Example dropdown menu",
		"textColor": c_white,
		"vmargin": 6,
	},
	dropdownButton,
	dropdownContainer]
}