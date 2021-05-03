---
layout: post
title: Simple CSS Pattern to Dynamically Abbreviate Text
date: 2019-11-26 21:50
categories: css blog
permalink: /css-content-breakpoints
thumbnail: /img/thumbnail/responsive-css-breakpoints.png
description: Use this CSS pattern to dynamically show or abbreviate text based on the amount of space that is available.
---

Ideally, an HTML element should be able to decide for itself
the best way that it should be displayed based on the current
amount of space that is available. This is the idea behind
[intrinsic design](http://www.zeldman.com/2018/05/02/transcript-intrinsic-web-design-with-jen-simmons-the-big-web-show/).

Instead of trying to design a static layout for one viewport and
then force my content into that layout, I start by writing
semantic HTML and then add a layer of CSS as a _suggestion_ for
my content so that the browser can decide what the best way to
render the page.

Consider the [sidebar layout](https://every-layout.dev/layouts/sidebar/) which splits up into a sidebar and main content area
based on the amount of space that is available.

![In a wider viewport some content may actually have less space](/img/2019-11-26-responsive/HorizontalToVertical.svg "In a wider viewport some content may actually have less space")

The content which is placed in the main content area will
actually have less space in the two column layout on certain
viewports. When I place content (like a table) into this area, I
want the table to have the ideal layout _regardless_ of how wide
my device or browser window currently is.

Consider the following table:

<div class="horizontal-scroll">
  <table>
    <thead>
      <tr>
        <th>
          Short Header
        </th>
        <th>
          SuperLongTableHeaderName
        </th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Long content which should actually take up more place</td>
        <td class="number">1</td>
      </tr>
    </tbody>
  </table>
</div>

The width of a column is determined based on the child element
with the largest content. However, when the content of a column
is more important than the header and the header is the cell
with the largest width, the column will take up more space than
necessary, potentially squeezing the content of other columns
and taking up valuable real estate.

<div class="horizontal-scroll">
  <table style="max-width: 300px">
    <thead>
      <tr>
        <th>
          Short Header
        </th>
        <th>
          SuperLongTableHeaderName
        </th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Long content which should actually take up more place</td>
        <td class="number">1</td>
      </tr>
    </tbody>
  </table>
</div>

What I want is to make the content in my table headers adjust to
the amount of space available, and if there is not enough space,
to show an abbreviation of the heading instead of the complete
text. But if there is enough space, I want to be able to show the
full column name.

Ideally, we would have content breakpoints in CSS and could do this.

Unfortunately, we do not have content breakpoints.

Because of this, I have looked into how we could do this using
CSS and was inspired by the [holy albatross](https://www.heydonworks.com/article/the-flexbox-holy-albatross) pattern
by Heydon Pickering as to how to switch content based on the
width of the parent container.

My markup for this is as follows:

```html
<span class="squishable"
      aria-label="Position"
      data-short="Pos" />
```

By using the `aria-label` attribute, the full unabbreviated text
will be available to a screen reader.

I then set the content of the `::before` and `::after`
pseudo-elements in my HTML

```css
.squishable::before {
  content: attr(data-short);
}
.squishable::after {
  content: attr(aria-label);
}
```

By default, both of the texts are now visible, but what I want is
to blend in one or the other based on the width that is available
in the column.

To do this, I define a content breakpoint for my span as a css
property

```css
.squishable {
  --squish-at: 1.5rem;
}
```

When the parent container is smaller than my `--squish-at` value,
I want to show the `.squishable::before` element. Otherwise, I
want to show the `.squishable::after` element.

The trick here is to use the `calc` function to derive the width
of the container (as I said before, this is inspired by the
[holy albatross pattern](https://www.heydonworks.com/article/the-flexbox-holy-albatross)) and to set the `max-width` property.

To set the `max-width` property, we need our pseudo-elements to
have block spacing and we also want to hide any overflow (e.g
when `max-width` is `0` we do not want to see anything).

```css
.squishable {
  white-space: nowrap;
}
.squishable::before,
.squishable::after {
  display: inline-block;
  overflow: hidden;
}
```

Now comes the magic!

When do we want to show our abbreviation? Here we can set the
`max-width` of the `::before` pseudo-element.

```css
.squishable::before {
  max-width: calc((var(--squish-at) - 100%) * 999);
}
```

This works because the calculation `var(--squish-at) - 100%` is
only positive when the parent container is smaller than `var(--squish-at)`. We then multiply it by the `999` magic number so
that it is a _really big positive number_ and since the width
of our abbreviation is smaller than this large `max-width` that
we have set, the element will definitely be visible.

The other side of the equation is that when the parent container
is larger than our `var(--squish-at)`, the calculation
`var(--squish-at) - 100%` will be a negative value. Because the
browser converts this negative `max-width` to `0`, this means
that if the parent container is larger than `var(--squish-at)`,
the abbreviation will not be visible.

We now do the same for the `::after` pseudo-element, except that
now we use `100% - var(--squish-at)` because this is the value
that is positive when the parent element is wider than our
content breakpoint.

```css
.squishable::after {
  max-width: calc((100% - var(--squish-at)) * 999);
}
```

And we add just a few styles for the table to make it more
responsive and make it possible for the columns headers to
shrink.

```css
.squishable-table {
  width: 100%;
}
.squishable-table th {
  max-width: 1.5rem;
}
```

Because I am using CSS properties, I can set the content
breakpoint for my column based on the content that is in it.
One easy way to estimate a breakpoint is by using the `ch` unit
and setting it to the number of characters in the `aria-label`
attribute. This isn't always a good breakpoint, because the `ch`
unit is based on the width of the `0` character, but it's a good
starting off point.

```html
<span class="squishable"
      aria-label="THN"
      data-short="No." /
      style="--squish-at: 25ch;">
```

The main point is that I can set it independently and based
on the content that I am putting inside of the element.

Now the width of the table we had before can be determined
based on the content of the table cells and not on the width
of the table header.

<table class="squishable-table" style="max-width: 300px">
  <thead>
    <tr>
      <th>
        <span class="squishable"
          aria-label="Short Header"
          data-short="Header"
          style="--squish-at: 5ch;"/>
      </th>
      <th>
        <span class="squishable"
          aria-label="SuperLongTableHeaderName"
          data-short="No."
          style="--squish-at: 25ch;" />
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Long content which should actually take up more place</td>
      <td class="number">1</td>
    </tr>
  </tbody>
</table>

Here's another table that you can play around with if you are
in a browser and can change the width of the viewport. And here
is the [Codepen](https://codepen.io/joyheron/pen/BaagQLe) of the
implementation.

<div class="horizontal-scroll">
  <table class="squishable-table">
    <thead>
      <tr>
        <th>
          <span class="squishable"
              aria-label="Position"
              data-short="Pos"
              style="--squish-at: 8ch;" />
        </th>
        <th>
          <span class="squishable"
              aria-label="Priority"
              data-short="Prio"
              style="--squish-at: 8ch;" />
        </th>
        <th>
          <span class="squishable"
              aria-label="Number"
              data-short="No."
              style="--squish-at: 6ch;" />
        </th>
        <th>
          <span class="squishable"
              aria-label="Address"
              data-short="Addr."
              style="--squish-at: 7ch;" />
        </th>
        <th>
          <span class="non-squishable">Name</span>
        </th>
        <th>
          <span class="squishable"
                aria-label="Telefone No."
                data-short="Tel."
                style="--squish-at: 11ch;" />
        </th>
      </tr>
    </thead>
    <tbody>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
      <tr><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td><td>&#8230;</td></tr>
    </tbody>
  </table>
</div>

<!-- ![Set the width of a table header responsively](/img/responsive-css-breakpoint.gif "Set the width of a table header responsively") -->
