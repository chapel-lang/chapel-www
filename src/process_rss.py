from rss_parser import RSSParser
from requests import get
from dateparser import parse
from urllib import parse as urlparse
from bs4 import BeautifulSoup
import json

feeds = [
    ("https://chapel-lang.org/blog/posts/index.xml", "https://chapel-lang.org/blog"),
# Use the 'make preview' copy of the blog's RSS feed (doesn't work b/c
# currently 'index.xml' is incorrect in our preview of the blog
#    ("http://localhost:1313/posts/index.xml", "http://localhost:1313/"),
]

items = []

author_cache = {}
try:
    with open("data/author_cache.json", "r") as f:
        author_cache = json.loads(f.read())
except FileNotFoundError:
    # Fine
    pass

def extract_chapel_authors(url):
    if url in author_cache:
        return author_cache[url]

    response = get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    authors = []

    def is_post_subscript(elem):
        return (
            elem.has_attr("class") and
            elem["class"] == ["post-subscript"]
        )

    for subscript in soup.find_all(is_post_subscript):
        for p in subscript.find_all("p"):
            if not p.text.strip().startswith("By:"):
                continue

            for a in p.find_all("a"):
                authors.append({
                    "name": a.text,
                    "url": urlparse.urljoin(url, a["href"])
                })

    author_cache[url] = authors
    return authors

for feed, baseurl in feeds:
    response = get(feed)

    rss = RSSParser.parse(response.text)

    for item in rss.channel.items:
        if len(item.links) == 0:
            continue
        link_url = item.links[0].content
        obj = {
            "title": item.title.content,
            "date": str(parse(item.pub_date.content)),
            "url": link_url,
            "description": item.description.content,
        }

        # As as a special case, fetch author information from the blog post
        authors = None
        if baseurl in link_url:  # Skip over external links for now
            authors = extract_chapel_authors(obj["url"])

        if authors is not None:
            obj["authors"] = authors

        items.append(obj)


items.sort(key=lambda x: x["date"], reverse=True)

with open("data/rss.json", "w") as f:
    f.write(json.dumps(items, indent=2))
with open("data/author_cache.json", "w") as f:
    f.write(json.dumps(author_cache, indent=2))
