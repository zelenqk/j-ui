main = {
	"width": 200,
	"height": 125,
	"bgType": bgSprite,
	"background": sTest,
	"repetition": 1,
	"overflow": hidden,
	"direction": dir.column,
	"step": function(){
		contentOffsetY += mouse_wheel_up() - mouse_wheel_down();
	}
}

var container = {
	"width": 180,
	"height": 100,
	"color": c_red,
	"overflow": hidden,
	"marginBottom": 2,
	"step": function(){
		contentOffsetX += keyboard_check(ord("D")) - keyboard_check(ord("A"));
	}
}

var mark = {
	"width": 10,
	"height": 10,
	"color": c_black,
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