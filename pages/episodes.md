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

<iframe width="100%" height="650" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/139584151%3Fsecret_token%3Ds-IprY9&amp;color=0066cc&amp;auto_play=false&amp;hide_related=true&amp;show_comments=false&amp;show_user=false&amp;show_reposts=false&amp;download=false&amp;buying=false&amp;liking=false&amp;sharing=false&amp;show_artwork=false&amp;show_playcount=false"></iframe>