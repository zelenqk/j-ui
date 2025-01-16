main = {
	"width": 200,
	"height": 125,
	"overflow": hidden,
	"direction": dir.column,
	"background": c_red,
	"color": c_blue,
	"alignItems": fa_center,
	"borderRadius": 12,
	"paddingH": 32,
	"goBack": 0,
	"onTrueHover": function(){
		color = c_blue;
	},
	"step": function(){
		color = c_red
		contentOffsetY += mouse_wheel_up() - mouse_wheel_down();
	}
}

var container = {
	"width": 180,
	"height": 100,
	"color": c_red,
	"justifyContent": fa_center,
	"direction": dir.box,
	"overflow": hidden,
	"marginBottom": 2,
	"borderRadius": 12,
	"step": function(){
		contentOffsetX += keyboard_check(ord("D")) - keyboard_check(ord("A"));
	}
}

var mark = {
	"width": 10,
	"height": 10,
	"color": c_black,
	"direction": dir.column,
	"marginRight": 2,
	"onHover": function(){
		color = c_blue;
	},
	"onClick": function(){
		show_message("hui");
	},
	"step": function(){
		color = c_black;	
	},
	"marginTop": 2
}

container.content = copy_styles_array(mark, 3);

main.content = copy_styles_array(container, 10);


textTest = {
	"width": 100,
	"height": 24,
	"text": "Hello world",
	"textFit": true,
	"display": display.flex,
	"newLine": true,
	"padding": 6,
	"borderRadius": 32,
	"textColor": c_red,
	"onHover": function(){
		color = c_blue;
		textColor = c_green;
	},
	"step": function(){
		color = c_white;
		textColor = c_black;
	}
}