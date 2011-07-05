--- 
layout: /mdub/weblog/_article.html.haml
title: The Three R's of Test Automation
draft: true
published: 
...

A have a few simple criteria I use to gauge the value provided by an automated test.  Even better, I've managed to rationalise them all starting with the same letter, so can now define:

<blockquote>
  <big><strong>The Three R's of Test Automation:</strong></big>
  <p>
    An automated test must be <strong>Rapid</strong>, <strong>Reliable</strong>, 
    and <strong>Relevant</strong>.
  </p>
</blockquote>

Automated tests are not _inherently_ valuable; they are not an end unto themselves.  So, what makes them valuable?  The obvious answer is that they provide useful feedback ... but, what makes that feedback useful?  I think feedback is only useful when it _mitigates risk_.  

Also, to properly assess a test's value, you need to consider not just the benefit it provides, but also the cost of creating, maintaining, and executing it.  When the cost outweighs the benefit, the test has ceased to provided value.

If a test fails, and that failure highlights a defect, which otherwise might have gone undetected for a while, then the test provided benefit.  On the other hand, when tests pass, and you trust them, then you gain the confidence that the 

Rapid 
-----

(could also be called "Responsive")

Quick tests are better than slow tests (all other things being equal).  They increase benefit by providing earlier feedback.  They reduce cost because they are cheaper to execute.

The cost of a slow test ...

Reliable
--------

Relevant
--------

(could also be called "Risk-focused")

Automated tests are less relevant when they test functionality which:

* is less valuable (e.g. the features that nobody uses)
* is less likely to fail (e.g. stable )
* is already well-tested


Summary
-------

