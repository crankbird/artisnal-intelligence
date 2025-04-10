---
layout: default
title: Home
---

# Welcome to Artisanal Intelligence 2.0

This is a space for human-first, AI-aware blogging — where provenance, clarity, and autonomy matter.

Check out the [design philosophy](/design), [attribution policy](/attribution), or [privacy details](/privacy).

## Latest Posts

<ul>
{% for post in site.posts %}
  <li>
    <a href="{{ post.url }}">{{ post.title }}</a>
    <small>Published on {{ post.date | date: "%B %d, %Y" }}</small>
  </li>
{% endfor %}
</ul>
