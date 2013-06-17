---
layout: /mdub/weblog/_article.html.haml
title: Playing with buildpacks on Cloud Foundry v2
draft: true
...

I'm currently messing about a bit with [Cloud Foundry][CloudFoundry], an open-source Platform-as-a-Service which promises to be something akin to Heroku-in-your-data-center, or perhaps Heroku-in-your-AWS-VPC.  In any case, it's exciting stuff, and appears to be moving fast, under the guidance of [Pivotal][Pivotal].

[CloudFoundry]: http://www.cloudfoundry.com
[Pivotal]: http://gopivotal.com

Brian McClain posted an [article][brians-post] recently about getting a Haskell app running in Cloud Foundry. I decided to do something similar using [Play][play].

[brians-post]: http://catdevrandom.me/blog/2013/05/16/buildpacks-in-cloud-foundry-v2/
[play]: http://www.playframework.com

I hadn't used Play before, but it turns out that it's pretty easy to get a basic app up and running using "play new".

<pre>
$ play new playpen
</pre>

A quick check locally, to check that everything is hanging together:

<pre>
$ cd playpen
$ play start
$ open http://localhost:9000
</pre>

All good, so let's try pushing it up to Cloud Foundry. I'll create a `manifest.yml` file to

    ---
    applications:
    - name: playpen
      memory: 256M
      instances: 1
      url: playpen.cfapps.io
      path: .


