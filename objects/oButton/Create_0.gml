button = {	//the button itself
	"textColor": c_white,
	"text": "Click me plz",
	"background": c_black,
	"display": flex,
	"fontSize": 64,
	"font": fntMain,
	"padding": 12,
	"onHover": {
		"alpha": "-0.55",
	},
	"onRelease": function(){
		show_message("Hello world!")	
	},
}

example = {	//a wrapper to add text above the button (content[0] is the text itself) you could use the text variable in the wrapper itself but then you would need to set "margintop": button.fontSize, so the text wont overflow
	"direction": column,
	"display": flex,
	"background": c_black,
	"alpha": 0.4,
	"fontSize": 32,
	"border": 4,
	"content": [{
		"display": flex,
		"text": "Example button",
		"fontSize": 24,
		"font": fntMain,
		"textColor": c_white,
		"background": noone,
		"vmargin": 2,	//add vertical margin to make the text look above the button
	},
		button
	]
}