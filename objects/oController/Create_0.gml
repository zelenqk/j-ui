main = {
	"width": 200,
	"height": 90,
	"alignItems": fa_center,
	"direction": dir.column,
	"overflow": hidden,
	"bgScale": 0.55,
	"padding": 1,
	"background": sTest,
	"bgType": bgSprite,
}

globalvar control;

control = create_surface(display_get_gui_width(), display_get_gui_height());

wrapping = {
	"width": 200,
	"height": 100,
	"overflow": hidden,
	"alignItems": fa_center,
	"direction": dir.column,
	"justifyContent": fa_center,
	"step": function(){
		contentOffsetY += mouse_wheel_up() - mouse_wheel_down();	
	}
}

var box = {
	"width": 170,
	"height": 100,
	"marginBottom": 4,
	"alignItems": fa_center,
	"justifyContent": fa_center,
	"overflow": hidden,
	"debug": true,
	"step": function(){
		color = c_red;
		contentOffsetX += keyboard_check(ord("D")) - keyboard_check(ord("A"));
	},
	"onHover": function(){
		color = c_yellow;	
	}
}

var checker = {
	"width": 10,
	"height": 10,
	"marginRight": 2,
	"step": function(){
		color = c_black;
	},
	"onHover": function(){
		color = c_blue;	
	},
	"debug": true,
}

box.content = copy_styles_array(checker, 10);

wrapping.content = copy_styles_array(box, 10);