---
layout: post
title: Modern CSS - Container Queries are almost here!
date: 2021-05-03 15:00
categories: css
permalink: /modern-css
description: A collection of links for getting started with container queries
---

I am giving a talk at the
[INNOQ Technology Night](https://www.innoq.com/en/talks/2021/05/innoq-technology-night-06-05-2021/)
(in German) about modern CSS and container queries.
The talk is audio-only, but I wanted to provide this page as a reference for those who want
to follow along during my talk or for those who want to look up the links after the fact.

The [CSS isn't easy](https://wizardzines.com/comics/css-isnt-easy/) comic by
[Julia Evans](https://twitter.com/b0rk) really encapsulates my feeling about CSS:

> CSS may _seem_ easy, but _layout_ is a really difficult problem. Modern CSS has
> _evolved_ to the point where it can very eloquently solve this problem -- and
> it's getting better all the time.

For those who want a deeper look at the intricacies which are involved in website
layout, I recommend [this in-depth look at how page layout is implemented in browsers](http://browser.engineering/layout.html) from the [Web Browser Engineering](http://browser.engineering/index.html) book.

When web development began, CSS didn't provide any mechanisms for implementing layout.
This is why web developers ended up misusing tables and floats to do layout.
Over the years, we've gotten [Flexbox](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox)
and [CSS Grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout) -- changes that
were always backwards compatible and drastically improved what we as developers can do.

## CSS Containment

The [CSS Containment](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Containment)
spec has also been added to modern browsers. With CSS containment, we can give the
browser more contextual information about our webpage:

* `contain: layout` - tells the browser that everything inside the element does not
  affect anything else on the page
* `contain: size` - tells the browser that the size of the children cannot affect the
  size of the element itself
* `contain: paint` - tells the browser that all of the visible content will be printed
  inside of the element's box -- anything outside of the box will be clipped

## Container Queries

Because of the progress made with CSS containment, we now have the tools to
implement _container queries_ in a way that doesn't totally kill performance.
Here is the [Container Queries spec](https://github.com/w3c/csswg-drafts/issues/5796) proposed by [Miriam Suzanne](https://www.miriamsuzanne.com/).
An implementation of this spec is now available behind a flag in the Canary Release of the Chome browser.

These excellent tutorials give a good overview of what we can currently do with container queries,
as well as providing some rationale for why we need them and examples of how to use them:

* [CSS Container Queries](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Container_Queries) is a write
  up on MDN by [Rachel Andrew](https://rachelandrew.co.uk/about/)
* [Container Queries are actually coming](https://piccalil.li/blog/container-queries-are-actually-coming/) by
  [Andy Bell](https://twitter.com/piccalilli_)
* [Say Hello to CSS Container Queries](https://ishadeed.com/article/say-hello-to-css-container-queries/) by
  [Ahmad Shadeed](https://ishadeed.com/about/)

**_TL;DR_**

We will be able to activate CSS containment for a specific area in our markup:

```css
main {
  contain: layout inline-size;
}
```

And then we can declaratively write CSS which will only activate when
our component has enough space.

```css
.component { /* Base CSS for component */ }

@container (min-width: 25rem) {
  .component {
    /* Styles when the component has more space */
  }
}
```

An important key to this puzzle is progressive enhancement.
We can create a
[minimal viable experience](https://piccalil.li/blog/a-minimum-viable-experience-makes-for-a-resilient-inclusive-website-or-app/)
for all modern browsers, and then add container queries as an optional
feature -- older browsers will ignore them because they don't understand
them yet, but if our [minimal viable experience is good enough, users
won't even realize that they don't have the optimal experience](https://twitter.com/piccalilli_/status/1349718686823813121)


### Other Links

If you are interested in this topic, consider checking out my other resources:

* [Responsible Web Apps](https://responsibleweb.app/): My site which discusses how to
  create websites which are responsive and accessible out-of-the-box
* [Case Podcast with Rachel Andrew](https://www.case-podcast.org/33-rachel-andrew-on-contributing-to-css-and-css-layout):
  I had the privilege of interviewing Rachel Andrew and discussed -- among other things --
  how much we all want container queries
* [INNOQ Podcast: Intrinsic Design](https://www.innoq.com/de/podcast/074-intrinsic-design/) (German):
  A podcast where I talk about responsive design and its successor: intrinsic design
* [INNOQ Podcast: Responsible Web Apps](https://www.innoq.com/de/podcast/084-responsible-web-apps/) (German):
  A podcast where I talk about responsible web applications (covering a lot of content from the
  [responsibleweb.app](https://responsibleweb.app) website)
