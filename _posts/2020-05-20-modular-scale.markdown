---
layout: post
title: Using Modular Scale to Achieve Consistent Design
date: 2020-05-20 21:46
categories: css blog
permalink: /2020-modular-scale-migration
thumbnail: /img/2020-05-20-modular-scale/modular-scale.png
image: /img/2020-05-20-modular-scale/modular-scale.png
description: My experiences moving my website over to modular scale in order to have more consistent spacing
---

One of the first things that I learned as a developer trying to improve my design skills is that spacing makes a huge difference for the visual design of a site.
It seemed counterintuitive to me that we need to _design_ our whitespace since it is the part of our page which actually does not have any content.
However, I quickly found out that choosing a well thought out spacing scheme can drastically approve the appearance of the site, even we do nothing else.

For my new spacing scale, I wanted to try out [Modular Scale](https://www.modularscale.com/).
The website provides a calculator to choose different bases and ratios to come up with a spacing scale.

I intentionally chose `1.125rem` (`18px`) for my font size because I believe that having a larger font size than average (the browser default is `1rem` or `16px`) improves the readability of the site.
I wanted to use this value for my modular scale as well, so I set that as my base and tried out a few different ratios to see what values they would produce.
After a few attempts, I settled on using the golden section for my ratio.
The full scale can be seen [here](https://www.modularscale.com/?1.125&rem&1.618).

I was already using spacing variables in order to define the different spacings on my site.
I like using variables with T-Shirt size labels so that I have a limited selection of spacing values that I can use.
Using the new values that I generated from my modular scale, my spacing variables (which I define using CSS properties) now are defined as follows:

```css
:root {
  --space-xxs: 0.266rem;
  --space-xs: 0.43rem;
  --space-sm: 0.695rem;
  --space-md: 1.125rem;
  --space-lg: 1.82rem;
  --space-xl: 2.945rem;
  --space-xxl: 4.765rem;
}
```

Since I was already using spacing variables,
modifying the CSS properties meant that all of my whitespace was automatically using the new scale.

I also wanted to be intentional about choosing font-sizes for my design which also correspond to the same scale.
This is the mistake which I made with the previous design which made it look... not quite as harmonious as I would desire.

My new font sizes are as follows:

```css
:root {
  --font-size-sm: 0.695rem; // For small text, tags, etc.
  --font-size-md: 1.125rem; // Base font size
  --font-size-lg: 1.82rem;  // For headings
  --font-size-xl: 2.945rem; // For h1 tag
}
```

I really like the effect on large viewports with the really big headings,
but I also found that on mobile the text was a bit too large for the viewport.

To modify this, I created variable font sizes which add `vw` units to a base size.
For instance, for the `--font-size-xl` Variable that I want to use for my `h1` tags,
I can write the following CSS:

```css
:root {
  --font-size-xl-grow: min(var(--font-size-lg) + 2vw,
                           var(--font-size-xl));
}
```

Here the `var(--font-size-lg) + 2vw` calculation means that my font size will start out at my base `--font-size-lg` and add two `vw` units to that value.
Since `2vw` is smaller on mobile than on a desktop or tablet with a wider viewport,
the resulting text is smaller on mobile and fits better within the viewport.

I wrapped this calculation in a CSS `min` function with my previous value `var(--font-size-xl)`.
This provides a clamp on the value,
so that as soon as `var(--font-size-lg) + 2vw` is larger than `var(--font-size-xl)`,
the `--font-size-xl` will be used.

The `min` function is [pretty widely supported](https://caniuse.com/#feat=css-math-functions),
but I did add an extra rule in my CSS with a hardcoded value for browsers that don't support it yet.

```css
h1 {
  font-size: 2.945rem; /* Fallback for older browsers */
  font-size: var(--font-size-xl-grow);
}
```

I made a similar calculation for `--font-size-md-grow` and `--font-size-lg-grow` which I want to use for `h2` and `h3` tags as well.

The final variable spacings are as follows:

```css
:root {
  --font-size-md-grow: min(var(--font-size-md) + 1vw,
                           var(--font-size-lg));
  --font-size-lg-grow: min(var(--font-size-md) + 2vw,
                           var(--font-size-xl));
  --font-size-xl-grow: min(var(--font-size-lg) + 2vw,
                           var(--font-size-xl));
}
```

I think this strikes a pretty nice balance in having a variable font size,
but one which still is based on the same spacing scale as the other values in the design.
Feel free to take a look at my [about](/about) page which I use as my personal design playground to see the effect.
