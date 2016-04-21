---
layout: page
title: Episodes
permalink: /episodes/
---

<div class='episode-list'>
  {% for post in site.posts %}
    <div>
        <div class='episode-link'><a href="{{ post.url }}">{{ post.title }}</a></div>
    </div>
  {% endfor %}
</div>
