---
layout: page
title: Episodes
permalink: /episodes/
---
<div class="home-heading">Latest</div>
<ul class="latest list"></ul>
<div class='episode-list'>
  {% assign sorted_posts = site.posts | sort: "episode" %}
  {% for post in sorted_posts reversed %}
    <div>
        <div class='episode-link'><a href="{{ post.url }}">{{ post.title }}</a></div>
    </div>
  {% endfor %}
</div>
