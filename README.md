# J-UI: A Simple Struct-Based UI System for GameMaker

![JUI_Banner](https://github.com/zelenqk/myGifz/blob/main/jui-banner.png)

J-UI is an easy-to-use, flexible, and highly customizable UI system designed specifically for GameMaker. With J-UI, creating complex UI components like buttons, dropdowns, sliders, and more becomes intuitive. All elements are structured in a JSON-like format, making it simple to build and manage your UI.

---

## Features

- **Struct-Based Design**: Define UI elements with a clear and modular structure.
- **Flexbox-Like Layouts**: Utilize flex properties such as direction, alignment, and gap for precise positioning.
- **Event Handling**: Built-in support for hover, click, release, and hold events.
- **Dynamic Styles**: Apply hover effects, animations, and responsive designs.
- **Composability**: Easily nest elements to create complex layouts.

---

## Example Usage

### Button Example
```gml
// Create event
button = {
	"textColor": c_white,
	"text": "Click me plz",
	"background": c_black,
	"display": flex,
	"fontSize": 64,
	"font": fntMain,
	"padding": 12,
	"onHover": {
		"alpha": "-0.55",  // Makes alpha relative: draw_set_alpha(draw_get_alpha() + real(alpha))
	},
	"onRelease": function(){
		show_message("Hello world!");
	},
};

// Draw GUI event
draw_container(button, x, y);
```

## Common Properties

Below is a comprehensive list of properties you can use to define your UI elements:
Text and Visual Properties

    text: A string displayed within the container.
    textColor: The color of the text.
    textAlpha: The alpha (transparency) of the text.
    halign: Horizontal alignment of text (fa_left, fa_center, fa_right).
    valign: Vertical alignment of text (fa_top, fa_center, fa_bottom).
    fontSize: Size of the text.
    scale: If less than 0, automatically scales text to fit the container, considering padding.
    background: Can be a color, sprite, surface, or noone for no background.

Layout and Positioning

    alignItems: Aligns content horizontally (fa_left, fa_center, fa_right).
    justifyContent: Aligns content vertically (fa_top, fa_center, fa_bottom).
    padding: Space between content and container edges.
    margin: Space between containers. Specific margins:
        hmargin: Horizontal margin.
        vmargin: Vertical margin.
        marginleft, marginright, margintop, marginbottom: Individual sides.
    border: Adds a visual border (does not affect usable size).
    overflow: Determines if content outside the container is hidden (hidden) or allowed (allow).
    display: Determines size behavior:
        fixed: Container has a fixed size.
        flex: Container size adjusts based on child content.
    direction: Layout direction (row, column).
    position: Position type:
        relative: Size affects parent container.
        absolute: Excluded from parent container sizing.

Events

    onHover: Triggered when the cursor hovers over the element.
    onClick: Triggered when the element is clicked.
    onHold: Triggered while the element is held.
    onRelease: Triggered when the element is released.
    otherwise: Triggered when none of the above events occur.
    step: Logic executed each frame.

Note: Events can be:

    A struct (e.g., { "alpha": "-0.25" }).
    A function (e.g., function(){ ... }).
    An array where the first index is a function and subsequent indices are arguments.

Additional

    parent: Refers to the parent container.
    drawContent: Whether the container draws its child content (true or false).

License

J-UI is open-source and free to use for personal and commercial projects. Attribution is appreciated but not required.
