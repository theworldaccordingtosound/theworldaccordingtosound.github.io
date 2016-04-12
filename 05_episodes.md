---
layout: page
title: Episodes
permalink: /episodes/
---

<table>
{% for post in site.posts %}
<tr>
  <td>
  {% assign index = forloop.index | modulo: 2 %}
  {% if index == 1 %}
    <img src="/assets/world_logo_bw_small.png">
  {% else %}
    <img src="/assets/world_logo_color_small.png">
  {% endif %}
  </td>
  <td>
    <a href="{{ post.url }}">
      {{ post.title }}
    </a>
  </td>
  <td>
  {{ post.excerpt | strip_html | truncatewords: 10 }}
  </td>
</tr>
{% endfor %}
</table>
