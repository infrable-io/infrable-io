# Sass

## Style Rules

### Nesting

But Sass wants to make your life easier. Rather than repeating the same selectors over and over again, you can write one style rules inside another. Sass will automatically combine the outer rule's selector with the inner rule's.

**Example**

```sass
nav {
  ul {
    margin: 0;
    padding: 0;
    list-style: none;
  }
  li {
    display: inline-block;
  }
  a {
    display: block;
    padding: 6px 12px;
    text-decoration: none;
  }
}
```

This is equivalent to the following CSS:

```css
nav ul {
  margin: 0;
  padding: 0;
  list-style: none;
}
nav li {
  display: inline-block;
}
nav a {
  display: block;
  padding: 6px 12px;
  text-decoration: none;
}
```

## Parent Selector

The parent selector, `&`, is a special selector invented by Sass that's used in nested selectors to refer to the outer selector. It makes it possible to re-use the outer selector in more complex ways, like adding a pseudo-class or adding a selector before the parent.

When a parent selector is used in an inner selector, it's replaced with the corresponding outer selector. This happens instead of the normal nesting behavior.

```sass
.alert {
  // The parent selector can be used to add pseudo-classes to the outer
  // selector.
  &:hover {
    font-weight: bold;
  }

  // It can also be used to style the outer selector in a certain context, such
  // as a body set to use a right-to-left language.
  [dir=rtl] & {
    margin-left: 0;
    margin-right: 10px;
  }

  // You can even use it as an argument to pseudo-class selectors.
  :not(&) {
    opacity: 0.8;
  }
}
```

This is equivalent to the following CSS:

```css
.alert:hover {
  font-weight: bold;
}

[dir=rtl] .alert {
  margin-left: 0;
  margin-right: 10px;
}

:not(.alert) {
  opacity: 0.8;
}
```
