---
layout: default
title: "Home"
---

# Welcome to {{ site.title }}

{{ site.description }}

<section class="post-list">
  {% for post in site.posts %}
  <article class="post-card">
    <a href="{{ post.url | relative_url }}">
      <div class="post-card-image" 
           style="background-image: url('{{ post.image | relative_url }}');">
      </div>
    </a>
    <div class="post-card-content">
      <h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
      <p class="post-meta">By {{ post.author }} on {{ post.date | date: "%B %d, %Y" }}</p>
      <p class="post-excerpt">{{ post.excerpt | strip_html | truncate: 150 }}</p>
    </div>
  </article>
  {% endfor %}
</section>