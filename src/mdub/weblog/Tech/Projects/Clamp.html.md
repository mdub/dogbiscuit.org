--- 
layout: /mdub/weblog/_article.html.haml
title: Clamp - a Ruby command-line framework
...

In the course of my current project, I've been writing a bunch of command-line utilities.  While they're just Ruby scripts, much of their work is interacting with the user: accepting command-line options and arguments, and providing useful feedback in case of errors.  So, I wrote a little framework to make it easier.  It's called [Clamp](http://github.com/mdub/clamp).

Clamp models a command as a Ruby class, and a command execution as an instance of that class.  Command classes look like this:

    class SpeakCommand < Clamp::Command

      option "--loud", :flag, "say it loud"
      option ["-n", "--iterations"], "N", "say it N times", :default => 1 do |s|
        Integer(s)
      end

      parameter "WORDS ...", "the thing to say", :attribute_name => :words

      def execute
        the_truth = words.join(" ")
        the_truth.upcase! if loud?
        iterations.times do
          puts the_truth
        end
      end

    end

At execution time, Clamp uses the "option" and "parameter" declarations to map command-line arguments onto the command object as instance variables.

There are numerous Ruby libraries out there to help with parsing of command-line options - even a couple built into the standard library - so why write something new?  Partly, it's because most of the alternatives only address option parsing.  I wanted to focus less on parsing options, and more on modelling the command itself.  Clamp is similar in some ways to [Thor](https://github.com/wycats/thor), the command framework behind Bundler and Rails3 generators, though Thor models commands as methods, rather than classes.  It's also quite a bit bigger.

Anyway, next time you're writing a command-line utility in Ruby, I hope you give Clamp a go, and that it makes your job a little bit easier.
