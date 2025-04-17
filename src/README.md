# Hugo source code for the new Chapel website

This README covers the following topics:
- Building a local version of the website
- Using the custom shortcodes that generate the various grids and carousels throughout the website
- Updating the homepage content, including the
  - Code examples
  - User testimonials
  - "Chapel in production" applications
  - Attribute cards
  -  Announcements
- Updating the attribute pages
- Adding new elements to the resources page


## Building and Viewing a Local Version

The website is built using `hugo`. It also uses a python script to gather the content for the "From our Blog" section. 

Installing `hugo` on macOS: 
```
brew install hugo
```

Generating the blog content information:
```
python3 process_rss.py
```

To preview the website using a local server, run from the `src` directory:
```
make preview
```

then navigate to https://localhost:1313/ (or whatever hugo says at the
end of its log) to view the local version.

To build the website's html and overlay it on the static website content
at ../chapel-lang.org/, use:

```
make www
```

## Homepage Content

### Title, Code Examples

The title and code sections of the homepage are configurable with the `config.toml` file. 
The title is set by the `title` field at the beginning of `config.toml`. 
The tagline is specified in the `params` entry.
The code examples are given as as elements of a list titled `param.codes`. Each code example should ahve a `name` field and a `code` field.

### Attribute Cards

The attribute cards are controlled by the `*.yaml` files within the `data/attributes` directory. 
Each file in the directory corresponds to a single attribute card, and should contain:
- a `name` field with the name of the attribute
- a `description` field with the description that appears under the name.
- a `url` field, with a absolute or relative path to the page the card should link to.
- a `weight` field, indicating the position it should take in the list of attributes.
The file can also contain other fields, but these will not impact how they are rendered.

To add more attributes, add new `*.yaml` files to the `data/attributes` directory.

### User Testimonials

The user testimonials are entries in the `config.toml` file, as elements of the `params.quotes` list.
Each entry requires:
- a `name` field, with the name of the quoted person.
- a `title` field, with the title of the quoted person.
- a `quote` field with the contents of their testimony.

### Application Examples

The examples for Chapel in Production section is controlled by the `params.applications` object in the `config.toml` file and by the `*.yaml` entries in `data/applications`. The `params.application` entry in the configuration file contrlos the title and subtitle present in the section. Each `*.yaml` file corresponds to a single application in the carousel. Each entry requires:
- a `name` field with the name of the application or project
- a `tagline` field with the short discription / tagline for the project
- a `text` field with the longer text description of the project
- a `image` field with the path of the image to use for the project
- a `url` field with a link to more information about the project
- a `weight` field to order the applications in the carousel

### Announcements

To add new announcments to the list of announcements, add a file to the `data/announcements` directory. The file should be `.yaml` file with the following fields:
- a `title` field with the title of the announcement
- a `description` field with the announcement body
- a `date` field with the date of the announcement, in the format YYYY-MM-DD
- a `url` field with a link for the "Continue Reading" button
- an `authors` field, which should be a list of authors. Each author entry needs at least a `name` entry, and can optionally have a `url` entry.

## Updating the Attribute Pages

The content of the attribute pages are controlled by the respective `*.md` files in the `content/` directory. For example, the Parallel page is controlled by the file `content/parallel.md`. 

Each of these content files begins with a metadata header, which contains toml entries, and is followed by the page's content. Shortcodes are used to render page elements based on the toml entries. See the Shortcodes section at the end of this document for more information about using shortcodes. 

## Adding New Elements to Resources pages

To add new resources to the resources pages, you will need to add entries to
`data/publications.toml` file, any relevant resource files to the `static/`
subdirectory, and possibly update the body of the `resources.md` page to render
your resources.

In any case, you'll need to add information about your new resource to
`data/publications.toml`. See comments in the `lint_artifacts.py` script for
how this information should be formatted. This script should be run to validate
any changes to the list.

## Shortcodes

Throughout many of the pages, common elements are reused: the grid, the carousel, and the code switcher.
These are generated using shortcodes (Hugo's version of functions for content pages). 

### TOML entries

The shortcodes all use the toml data in the header of markdown content pages to produce the different page elements. The toml data is at the top of each `.md` file, between two `+++` lines. Toml lists entries are specified as follows:

```
[[myListOfThings]]
  name="thing1"
  description="the first item in my list"
  url="https://www.firstThing.com"
  anotherField="another value"

[[myListOfThings]]
  name="thing2"
  description="the second item in my list"
  url="https:/www.chapel-lang.org"
  aDifferentField="a different value"
```

Note that two items in the same list can have different fields. In general, the shortcodes for the website expect that the list elements have the same fields.

### `grid`

The `grid` shortcode creates a grid of cards like that used for the attributes on the homepage. It takes a single argument, the name of the list of elements to render. Each element should have the following fields:
- `name`: the title to display on the card
- `description`: the text to display under the title
- `url`: the link for when the card is clicked on

### `switcher`

This shortcode creates the carousel used throughout the attribute pages. Each element requires the following fields:
- `title`: The title to display
- `description`: The description to display below the title
- `image`: A path to the image to display to the right of the text
- `url`: a link to take the user to when clicking
- `weight`: a weight used to sort the elements on the carousel

### `code-switcher`

This shortcode creates the code switcher used to compare between different versions of a code. Each element requires the following field:
- `name`: the name to use on the radio button
- `lang`: The language this piece of code is implemented in
- `codeFile`: A path to the file containing the code example

One of the elements should have the field `first="true` and one should have the field `second="true"`. This is how the default selection is determined for the two switchers.

