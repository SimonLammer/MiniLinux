---
title:     News
layout:    default
permalink: /news/
---

{% for post in site.categories.news %}
## [{{ post.title }}]({{ site.baseurl }}{{ post.url }})
{{ post.excerpt }}
{% endfor %}
