# J-UI: A Simple Struct-Based UI System for GameMaker
![JUI_Banner](https://github.com/zelenqk/myGifz/blob/main/jui-banner.png))

J-UI is an easy-to-use, flexible, and highly customizable UI system designed specifically for GameMaker. With J-UI, creating complex UI components like buttons, dropdowns, sliders, and more becomes intuitive. All elements are structured in a JSON-like format, making it simple to build and manage your UI.

---

## Features
- **Struct-Based Design:** Define UI elements with a clear and modular structure.
- **Flexbox-Like Layouts:** Utilize flex properties such as direction, alignment, and gap for precise positioning.
- **Event Handling:** Built-in support for hover, click, release, and hold events.
- **Dynamic Styles:** Apply hover effects, animations, and responsive designs.
- **Composability:** Easily nest elements to create complex layouts.

---

## Example Usage

### Button Example
```gml
//create event
button = {
	"textColor": c_white,
	"text": "Click me plz",
	"background": c_black,
	"display": flex,
	"fontSize": 64,
	"font": fntMain,
	"padding": 12,
	"onHover": {
		"alpha": "-0.55",  //setting the alpha makes it relative aka draw_set_alpha(draw_get_alpha() + real(alpha)); instead of just draw_set_alpha(alpha)
	},
	"onRelease": function(){
		show_message("Hello world!")	
	},
}

//draw gui event
draw_container(button, x, y);
```

