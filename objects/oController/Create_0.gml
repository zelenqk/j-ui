main = {
	"width": 200,
	"height": 90,
	"alignItems": fa_center,
	"direction": dir.column,
	"overflow": hidden,
	"step": function(){
		contentOffsetY += mouse_wheel_up() - mouse_wheel_down();	
	}
}

var box = {
	"width": 100,
	"height": 70,
	"color": c_red,
	"marginV": 12,
	"justifyContent": fa_center,
	"overflow": hidden,
	"step": function(){
		color = c_red;
		contentOffsetX += keyboard_check(ord("D")) - keyboard_check(ord("A"))
	},
	"onHover": function(){
		color = c_yellow;	
	}
}

var test = {
	"width": 20,
	"height": 20,	
	"marginH": 5,
	"color": c_blue,
	"step": function(){
		color = c_black;
	},
	"onHover": function(){
		color = c_blue;
	}
}

box.content = copy_styles_array(test, 12);

main.content = copy_styles_array(box, 12);