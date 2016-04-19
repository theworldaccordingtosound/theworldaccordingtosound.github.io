---
layout: page
title: Episodes
permalink: /episodes/
---

<div>
  {% for post in site.posts %}
    <div>
        <div><a href="{{ post.url }}">{{ post.title }}</a></div>
        <div>{{ post.excerpt | strip_html }}</div>
    </div>
  {% endfor %}
</div>
