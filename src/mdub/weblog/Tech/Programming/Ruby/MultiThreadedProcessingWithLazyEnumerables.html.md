--- 
layout: /mdub/weblog/_article.html.haml
title: Multi-threaded processing with lazy enumerables
draft: true
...

A project I'm working on at the moment involves processing a large collection (millions) of S3 objects, and I wanted to parallelize the processing across multiple threads.

As it happens, yt's actually pretty easy to process a Ruby collection using multiple Threads:

<pre><code class="ruby">inputs = [1, 2, 3]
threads = inputs.collect { |i| Thread.new { i * i } }
outputs = threads.collect { |thread| thread.join.value }
#=> [1, 4, 9]
</code></pre>

The problem with this naive approach, though, is that you end up creating a Thread for each element of the collection, all at once. For large collections, that's a bad idea. Typically you want to limit the number of Threads you having running simultaneously.

We can fix the do-everything-at-once problem using lazy enumeration:

<pre><code class="ruby">require 'lazily' # or use Ruby 2

inputs = [1, 2, 3]
lazy_threads = inputs.lazily.collect { |i| Thread.new { i * i } } # lazy!
outputs = lazy_threads.collect { |thread| thread.join.value }.to_a
#=> [1, 4, 9]
</code></pre>

Okay, but now we have the opposite problem: the worker Threads aren't created until immediately before their outputs are required, so we don't get any parallelization.

So, what if we reintroduced just a little eagerness, creating a sliding-window across the `lazy_threads` collection which forces some of them to be generating before we actually need them.  In other words, let's **prefetch** some of them:

<pre><code class="ruby">require 'lazily'

inputs = [1, 2, 3]
lazy_threads = inputs.lazily.collect { |i| Thread.new { i * i } }
prefetched_threads = lazy_threads.prefetch(10) # <- added magic
outputs = prefetched_threads.collect { |thread| thread.join.value }.to_a
#=> [1, 4, 9]
</code></pre>
