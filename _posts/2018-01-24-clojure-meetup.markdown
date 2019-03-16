---
layout: post
title: "core.async"
post-title: "core.async"
date: 2018-01-24 21:00
categories: sketchnote clojure-meetup
tags: clojure meetup
thumbnail: /img/thumbnail/2018-01-24-clojure-meetup/1.jpg
---

Today at the [Clojure Meetup in Düsseldorf](https://www.meetup.com/de-DE/Dusseldorf-Clojure-Meetup/), [Björn Ebbinghaus](https://twitter.com/MrOerni) presented Clojure's core.async for us. A very interesting evening! I love core.async!

Here are my notes:

![Clojure Meetup](/img/2018-01-24-clojure-meetup/1.jpg "Clojure Meetup")

After the talk, I absolutely had to try out working with core.async channels and transducers because I didn't know that worked!

<pre>
(defn c (chan 1 (map inc)))
</pre>

Whenever you put an element in a channel, the transformation in the transducer will be applied to the element before it is retrieved from the channel!

As a bonus, [Mario Mainz](https://twitter.com/m_mainz) helped me by giving me a few more tips about how to use spacemacs. I didn't actually close it immediately!

![Clojure Meetup](/img/2018-01-24-clojure-meetup/2.jpg "Clojure Meetup")
