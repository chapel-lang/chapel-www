# Chapel Website (chapel-lang/chapel-www)

This repository contains the Chapel website's sources (in src/) and
complete content (in chapel-lang.org).


## Previewing and building the website

The website is built using `hugo`. It also uses a `blog.json` file
created by `make www` in the `chapel-blog` repository to help populate
the news feed on the front page and `news/` page.

Installing `hugo` on macOS: 
```
brew install hugo
```

News items are generated from the `chapel-blog` repo using `make www`
from that repository.  This updates `assets/json/blog.json`, which
will then get merged into the announcements (see below).

To preview the website using a local server, run:
```
make preview
```

then navigate to https://localhost:1313/ (or whatever hugo says at the
end of its log) to view the locally hosted version.

To build the website's html and overlay it on the static website
content at ./chapel-lang.org/, run:

```
make www
```


## Contributing changes

When opening PRs to propose changes to the website, please make PRs
against the `src/` directory, relying on web maintainers to update the
rendered HTML in `chapel-lang.org/`, to reduce the chances of
conflicts, diffs due to differing hugo versions, etc.  See
`src/README.md` for more details about how the site's sources work and
are organized.

Note that PDFs for papers, presentations, etc. are stored in
directories like `chapel-lang.org/papers/` and
`chapel-lang.org/presentations/` to avoid duplication in the
repository, as this accounts for a large amount of the repo's size.
PRs adding new artifacts should feel free to add new files to such
directories.


