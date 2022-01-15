# CSS

## CSS Colors

### CSS Text Color

The `color` property is used to specify the color of text:

```css
// set text color to black (HEX: #000000)
color: #000000;
```

### CSS Background Color

The `background-color` property is used to specify the background color for HTML elements:

```css
// set background color to white (HEX: #ffffff)
background-color: #ffffff;
```

### CSS Color Values

In CSS, colors can also be specified using RGB values, HEX values, HSL values, RGBA values, and HSLA values.

## CSS Properties

### CSS `border-bottom` Property

The `border-bottom` property is a shorthand property for (in the following order):

* `border-bottom-width`
* `border-bottom-style`
* `border-bottom-color`

If `border-bottom-color` is omitted, the color applied will be the color of the text.

```css
border-bottom: width style color;
```

### CSS `padding` Property

The `padding` property is a shorthand property for:

* `padding-top`
* `padding-right`
* `padding-bottom`
* `padding-left`

```css
padding: top right bottom left;
```

```css
padding: top right+left bottom;
```

```css
padding: top+bottom right+left;
```

```css
padding: all;
```

### CSS `display` Property

The `display` property specifies the display behavior (the type of rendering box) of an element.

#### Property Values

* `flex`: Displays an element as a block-level flex container

### CSS `flex` Property

The `flex` property is a shorthand property for:

* `flex-grow`
* `flex-shrink`
* `flex-basis`

The `flex` property sets the flexible length on flexible items.

**NOTE**: If the element is not a flexible item, the `flex` property has no effect.

```css
flex: grow shrink basis;
```

### CSS `align-items` Property

The `align-items` property specifies the default alignment for items inside the flexible container.

```css
// center the alignments for all the items of the flexible <div> element
div {
  display: flex;
  align-items: center;
}
```

#### Property Values

* `center`: Items are positioned at the center of the container

### CSS `justify-content` Property

The `justify-content` property aligns the flexible container's items when the items do not use all available space on the main-axis (horizontally).

```css
// align the flex items at the center of the container
div {
  display: flex;
  justify-content: center;
}
```

**NOTE**: Use the `align-items` property to align the items vertically.

#### Property Values

* `space-between`: Items will have space between them

### CSS `position` Property

The `position` property specifies the type of positioning method used for an element (static, relative, absolute, fixed, or sticky).

#### Property Values

* `static`: Default value. Elements render in order, as they appear in the document flow
* `absolute`: The element is positioned relative to its first positioned (not static) ancestor element
* `fixed`: The element is positioned relative to the browser window
* `relative`: The element is positioned relative to its normal position, so "left:20px" adds 20 pixels to the element's LEFT position
* `sticky`: The element is positioned based on the user's scroll position. A sticky element toggles between `relative` and `fixed`, depending on the scroll position. It is positioned relative until a given offset position is met in the viewport - then it "sticks" in place (like `position:fixed`).
* `initial`: Sets this property to its default value. Read about initial
* `inherit`: Inherits this property from its parent element. Read about inherit

### CSS `width` Property

The `width` property sets the width of an element.

The width of an element does not include padding, borders, or margins!

**NOTE**: The `min-width` and `max-width` properties override the `width` property.

### CSS `z-index` Property

The `z-index` property specifies the stack order of an element.

An element with greater stack order is always in front of an element with a lower stack order.

**NOTE**: `z-index` only works on positioned elements (`absolute`, `relative`, `fixed`, or `sticky`) and flex items (elements that are direct children of `display:flex` elements).

**NOTE**: If two positioned elements overlap without a `z-index` specified, the element positioned last in the HTML code will be shown on top.

## CSS Selectors

### The CSS class Selector

The class selector selects HTML elements with a specific class attribute.

To select elements with a specific class, write a period (`.`) character, followed by the class name.

**Example**

```css
.class {
  property: value;
  ...
}
```
