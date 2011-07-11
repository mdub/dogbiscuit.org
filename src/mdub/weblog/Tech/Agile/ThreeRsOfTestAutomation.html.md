--- 
layout: /mdub/weblog/_article.html.haml
title: The Three R's of Test Automation
published: 11-Jul-2011, 22:00
...

To properly assess a test's value, you need to consider both the benefit it provides, <u>and</u> the cost of creating, maintaining, and executing it.  When the cost outweighs the benefit, the test has ceased to provide (net) value.

A have a few simple criteria I use to gauge the value provided by an automated test.  Even better, I've managed to rationalise them all starting with the same letter, so now proclaim:

<blockquote>
  <big><strong>The Three R's of Test Automation:</strong></big>
  <p>
    An automated test must be <strong>Rapid</strong>, <strong>Reliable</strong>, 
    and <strong>Relevant</strong>.
  </p>
</blockquote>

Rapid 
-----

All other things being equal, quick tests are better than slow tests.  Quick tests add more value, because they provide feedback earlier, and can be executed more often.

Quick tests require fewer resources to execute, reducing cost.  Often, the maintanance cost is also lower, as quick tests tend to be simpler and involve fewer moving parts.

Reliable
--------

If a test fails, and that failure highlights a defect, which otherwise might have gone undetected for a while, then the test provided value.  There's also sustantial value in the confidence gained when tests pass.  

The benefit can quickly be eroded, though, if tests are not trustworthy.  Where they are known to be deficient, then additional manual testing must be performed to gain confidence, which undermines the value of test automation.

Also, tests can turn into a major maintenance burden if they're overly specific, or too tied to implementation details, because they become fragile - breaking not because of an introduced defect, but because something unimportant changed.

Relevant
--------

Automated tests are not _inherently_ valuable; they are not an end unto themselves.  So, what makes them valuable?  The obvious answer is that they provide useful feedback ... but, what makes that feedback useful?  I think feedback is only useful when it _mitigates risk_.  

If a test fails, and that failure highlights a defect (which otherwise might have gone undetected for a while), then the test provided value.  There's also sustantial value in the confidence gained when tests pass.

Automated tests are less relevant when they test functionality which:

* is less valuable (e.g. the features that nobody uses)
* is less likely to fail (e.g. stable)
* is already well-covered by other tests

Summary
-------

When considering whether to create an automated test, or retain an existing one, consider both:

* How valuable is the feedback it provides?
* How much will it cost you to maintain and execute it?
