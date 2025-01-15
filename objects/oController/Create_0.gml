main = {
	"width": 200,
	"height": 125,
	"overflow": hidden,
	"direction": dir.column,
	"background": c_red,
	"color": c_blue,
	"alignItems": fa_center,
	"paddingH": 32,	
	"borderRadius": 12,
	"goBack": 0,
	"step": function(){
		contentOffsetY += mouse_wheel_up() - mouse_wheel_down();
	}
}

var container = {
	"width": 180,
	"height": 100,
	"color": c_red,
	"overflow": hidden,
	"justifyContent": fa_center,
	"alignItems": fa_center,
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
	"step": function(){
		color = c_black;	
	}
}

container.content = copy_styles_array(mark, 10);

main.content = copy_styles_array(container, 10);


textTest = {
	"width": 100,
	"height": 24,
	"text": "Hello world",
	"textFit": true,
	"newLine": true,
	"textColor": c_red,
}