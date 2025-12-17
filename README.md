# Course Catalog

This repository is a Hugo-based static site that publishes a searchable course catalog. It contains course pages, site templates, and the structured data used to build and serve the catalog at `assets/data/courses.json`.

Live demo: <https://braskie.github.io/courseCatalog/>

## Repository structure (important paths)

- `content/` — markdown content for course pages and site sections.
- `layouts/` — Hugo templates and shortcodes used to render pages.
- `assets/data/` — JSON data consumed by the frontend; generated file is `assets/data/courses.json`.
- `datasource/` — scripts and tools for converting original data (SQL, CSV, etc.) into the JSON/YAML used by the site.
