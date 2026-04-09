This repository contains the Chapel website's sources (in src/) and
complete content (in chapel-lang.org).

When opening PRs to propose changes to the website, please make PRs
against the `src/` directory, relying on web maintainers to update the
rendered HTML in `chapel-lang.org/`, to reduce the chances of
conflicts, diffs due to differing hugo versions, etc.  See
`src/README.md` for more details about how the site's sources work and
are organized.

Note that PDFs for papers, presentations, etc. are stored in
`chapel-lang.org/papers/`, `chapel-lang.org/presentations/`, and the
like to avoid duplication in the repository, and PRs adding new
artifacts should feel free to add new files to such directories.
