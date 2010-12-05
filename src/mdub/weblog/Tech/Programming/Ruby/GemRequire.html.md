--- 
layout: /mdub/weblog/_article.html.haml
title: "\"gem require\""
published: Dec 6 2010, 09:00
...

One thing that irks me about Rubygems is that it provides no cheap way to ensure that a gem is installed.  For instance, in a script, I want to check that I've got "heroku" installed, before calling it.  My options include:

- just assume it's installed, and fail if the assumption is bad;
- call "`gem install`", knowing that it will needlessly re-install the gem if it's already installed;
- try calling "`heroku`", and fall back to "`gem install`" if it fails.

I'm not happy with any of those options, so a wrote a simple gem command plugin to make it easier.  Install it like so:

    $ gem install gem_require
    Successfully installed gem_require-0.0.3
    1 gem installed

Now you can use "`gem require`" in place of "`gem install`".  It's similar, except that it short-circuits if you already have the required gem installed:

    $ gem require heroku
    heroku (1.11.0) is already installed

If you want to ensure that you're on the bleeding edge, use the "`--latest`" option:

    $ gem require --latest heroku
    Installing heroku (1.14.6) ...
    Installed heroku-1.14.6

Of course, if you already **have** the latest version, there's no need to re-install it:

    $ gem require --latest heroku
    heroku (1.14.6) is already installed

I hope that helps somebody else.
