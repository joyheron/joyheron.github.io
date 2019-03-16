---
layout: post
title: "Spacemacs + Clojure"
post-title: "Spacesmacs + Clojure = ?"
date: 2017-08-17 23:00
categories: post sketchnote clojure-meetup
tags: clojure meetup
thumbnail: /img/thumbnail/2017-08-17-spacemacs.jpg
---

Editors are always a tricky subject for me. Clojure is my favorite language, but there are many different editor options, and up to now, I haven't found the perfect one. I've tried Emacs multiple times, but I have the problem that I quickly develop [Emacs pinky](http://ergoemacs.org/emacs/emacs_pinky.html) when using it and I also always forget the commands. I tried [Cursive](https://cursive-ide.com/) for a while and really liked it but didn't want to spend the money on a license for the little hacking which I do in my free time (and which isn't open source yet so I don't feel I can use the free license). My fallback is [Nightcode](https://sekao.net/nightcode/) because it does what it says it does, has par-infer and pretty much stays out of my way.

However, I have seriously considered attempting to attack and conquer the Emacs mountain for quite some time. One thing that I really would like (and which Nightcode doesn't offer me) is live reloading of all namespaces upon change so that I can better take advantage of the reloading feature of my [system](https://github.com/danielsz/system) based applications. I think Emacs might be able to offer that to me so that's why I am trying to learn it yet again.

The Emacs version I am using is [(spacemacs)](http://spacemacs.org/) with Evil mode enabled (with the hope that my pinkys stay in tact).

I should note at this moment I am neither a proficient Emacs user nor a proficient Vim user, so I will be having to learn both Spacemacs + Vim bindings. I then installed the Clojure layer in Spacemacs (although that was a while ago, so I don't really remember how I did that).

I just got back from the [Clojure Meetup in Düsseldorf](https://www.meetup.com/de-DE/Dusseldorf-Clojure-Meetup/). We did a Dojo evening again and I took the opportunity to grab someone to teach me a bit how to use spacemacs.

I sketchnoted the tutorial and I am going to try to briefly jot down the steps that we took and my impressions about the process before I completely forget them (and also translate some of my notes because they ended up in Denglish). Please note that my "guide" is definitely not complete. This is just the beginning of a journey that will hopefully not end today.

# Navigating in Emacs

In Emacs there are two main command keys: Control (C) and Alt/Meta (M). There are loads and loads of combinations. I think there is usually a tutorial in Emacs the first time you open it which teaches you a lot of them. I did it a couple of times already, but I already forgot a lot of them. Here are a few that I jotted down this evening.

`M-x + SPACE` -> Calls up the main menu

`M-m + p + t` creates a project tree within your emacs window so you can view the files in your directory like a normal editor!

`,` -> Calls up the Clojure specific menu (I think this might call up the layer specific commands, but I only use the Clojure level)

You can switch between buffers (which Emacs has open in the background) with `M-m b n`. I personally think this is really confusing and I'm hoping it gets easier.

`M-x + SPACE` calls up a list of all commands that you can search with. You can start typing the name of the command and it gets shorter.

In Spacemacs `SPACE + SPACE = M-x` (which might be why it is called _space_ macs)

# Starting a REPL

One of the main strengths of using Emacs for Clojure is the integration with the REPL. You can select specific expressions in Emacs and then send them to the REPL for evaluation.

The easiest way is with `M-x cider-jack-in` which will start a REPL.

Another way is to start a REPL in a console using `lein repl` and then use `M-x cider-connect` to connect to that REPL. Note that in order for this to work with all evaluation commands (e.g. 'C-c C-p') you will also need to install the `cider-nrepl` leiningen plugin. You can do this by modifying your `~/.lein/profiles.clj` file so that it contains `:plugins [[cider/cider-nrepl "0.15.0"]]` ([see more](https://github.com/clojure-emacs/cider-nrepl)).

# Evaluating Expressions in Spacemacs

There are several different commands for evaluating Clojure expressions.

`C-c C-k` will load and evaluate the whole namespace that you currently have open.

It is also possible to evaluate specific expressions.

If you have placed your cursor **_behind_** an expression

`(anexpr ...)^` (`^` is where the cursor is) you can evaluate it as follows:

`C-c C-e` evaluates the expression and then shows the result _inline_

`C-c C-p` evaluates the expression and shows both the result and the print output of a program in a separate buffer. This is especially needed when calling a function `(doc fn)` whose main purpose is to print a result.

The problem with these is that you can't use them that easily with Vim Evil unless you are in insert mode because you can't put your cursor behind an expression unless you are in insert mode.

There is another command `cider-eval-sexp-at-point` which evaluates an expression when you put your cursor **_on_** or **_before_** the opening parenthesis in the expression

`^(expr ...)` or `[(]expr ...)` where `^` and `[]` represent the cursor (or just look at the sketchnote :X ...)

If you then execute `C-c C-v C-v` it will eval the expression and display the result inline. This command works with Evil mode which is good.

# Configuring Spacemacs

At this point I configured my Spacemacs.

To do this, you can execute `M-m f e d` (to modify the dotfile). You can find the `(defn docspacemacs/user-config ())` function and modify it. I pretty much just copied and pasted it so I am copying and pasting the config here. What this does (as far as I can tell) is to add commands to increase/lower font size, ignore .gitignore files when grepping (which I haven't yet done), turn on strict mode for smartparens and overwrite and change some of the keybindings for smartparens mode. Those are useful in the next section.

<pre>
(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; Resize font
  (define-key global-map (kbd "C-+") 'text-scale-increase)
  (define-key global-map (kbd "C--") 'text-scale-decrease)

  ;; Helm configurations
  (setq projectile-use-git-grep 1) ;; Don't grep files listed in .gitignore
  ;; Clojure hooks

  ;; Setup smartparens
  (add-hook 'clojure-mode-hook 'turn-on-smartparens-strict-mode)
  (bind-keys
   :map smartparens-mode-map
   ("C-M-a" . sp-beginning-of-sexp)
   ("C-M-e" . sp-end-of-sexp)

   ;("C-&lt;down>" . sp-down-sexp)
   ;("C-&lt;up>"   . sp-up-sexp)
   ;("M-&lt;down>" . sp-backward-down-sexp)
   ;("M-&lt;up>"   . sp-backward-up-sexp)

   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)

   ("C-M-n" . sp-next-sexp)
   ("C-M-p" . sp-previous-sexp)

   ("C-S-f" . sp-forward-symbol)
   ("C-S-b" . sp-backward-symbol)

   ("M-&lt;right&gt;" . sp-forward-slurp-sexp)
   ("M-&lt;left&gt;" . sp-forward-barf-sexp)
   ;("C-&lt;left&gt;"  . sp-backward-slurp-sexp)
   ;("M-&lt;left&gt;"  . sp-backward-barf-sexp)

   ("C-M-t" . sp-transpose-sexp)
   ("C-M-k" . sp-kill-sexp)
   ("C-k"   . sp-kill-hybrid-sexp)
   ("M-k"   . sp-backward-kill-sexp)
   ("C-M-w" . sp-copy-sexp)

   ("C-M-d" . delete-sexp)

   ("M-&lt;backspace&gt;" . backward-kill-word)
   ("C-&lt;backspace&gt;" . sp-backward-kill-word)
   ([remap sp-backward-kill-word] . backward-kill-word)

   ("M-[" . sp-backward-unwrap-sexp)
   ("M-]" . sp-unwrap-sexp)

   ("C-x C-t" . sp-transpose-hybrid-sexp)

   ("C-c ("  . wrap-with-parens)
   ("C-c ["  . wrap-with-brackets)
   ("C-c {"  . wrap-with-braces)
   ("C-c '"  . wrap-with-single-quotes)
   ("C-c \"" . wrap-with-double-quotes)
   ("C-c _"  . wrap-with-underscores)
   ("C-c `"  . wrap-with-back-quotes)))
</pre>

# Editing Clojure

### Paredit

The first think to do is to `M-x smart-parens` to make sure that smart-parens is activated. The config above also enables strict mode by default for Clojure which means you can't accidentally delete parentheses and that is very helpful.

With smart-parens you can pretty much just start typing Clojure and everything is good. Sometimes, however, you might have an expression behind another expression `(expression1 ^) (other-expr ...)`. With `M-x sp-forward-slurp-sexp` you can **_slurp_** that expression into the other one `(expression1 ^ (other-expr ...))`.

You might also find that you have an expression within another expression `(expression1 ^ (expr2 ...))` and want it to be outside of the parentheses. Then with `M-x sp-forward-barf-sexp` you can **_barf_** it out: `(expression1 ^) (expr2 ...)`

There are other Paredit commands that you can look at. They are all prefixed with `sp-*`.

Because slurp and barf are so commonly used, the config above maps them to M-&lt;right&gt; and M-&lt;left&gt; so you can easily slurp and barf expressions.

### A few other useful commands

`M-x comment-region` comments an expression

`C-k` deletes an expression when your cursor is at the beginning of the expression (this is an emacs command, I don't know the Evil equivalent yet)

# To look at...

I will be looking at the `cider-refresh` command in my free time because I hope that will solve my problem with my reloadable applications.

# And here's the Sketchnote

All in all, a very informative and productive evening!

![Spacemacs](/img/2017-08-17-spacemacs.jpg "Spacemacs")
