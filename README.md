# GitHub action to audit a Hugo site build

Description: Build a Hugo website and [audit for silent
  errors](https://discourse.gohugo.io/t/audit-your-published-site-for-problems/35184/8).
  Optionally generate output and/or an artifact for use by other jobs in a
  GitHub Actions Workflow (e.g. for other tests or deployment).\
Repository URL: <https://github.com/wildtechgarden/audit-build-action-hugo>\
Site: <https://www.audit-build-action-default.wtg-demos.ca>\
CI Status: [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/wildtechgarden/audit-build-action-hugo/main.svg)](https://results.pre-commit.ci/latest/github/wildtechgarden/audit-build-action-hugo/main)
[![test-build-audit](https://github.com/wildtechgarden/audit-build-action-hugo/actions/workflows/test-build-audit.yml/badge.svg)](https://github.com/wildtechgarden/audit-build-action-hugo/actions/workflows/test-build-audit.yml)

## Contents

1. [Contents](#contents)
2. [Configuration and Usage](#configuration-and-usage)
   1. [Action inputs variables](#action-inputs-variables)
   2. [Action outputs variables](#action-outputs-variables)
   3. [Sample usage](#sample-usage)
      1. [Single hugo.toml](#single-hugotoml)
      2. [With an extra configuration file](#with-an-extra-configuration-file)
3. [Development](#development)
4. [Colophon](#colophon)

## Configuration and Usage

### Action inputs variables

| Input | Description | Required | Default |
|-------|-------------|-------|---------|
| base-url | Set the baseURL for the site (for this build only) | false | |
| build-for-downstream | Build for use by another action or step (aka bundle) without an artifact (string: "true" or "false" | true | "false" |
| checkout-fetch-depth | Fetch depth (recommend using 0 to fetch all history if using .GitInfo or .Lastmod) | true | 0 |
| checkout-submodules | Fetch git submodules: false, true, or recursive | true | false |
| code-directory | Directory under which repo and modules will live | true | ${{ github.workspace }}/code |
| config-file | Hugo configuration file to use for the build(s) (may be a comma-separated list of files, relative to the 'source' dir) | true | "config.toml" |
| do-minify-audit | If present, minify site using --minify before audit | false | |
| do-minify-bundle | If present, minify site using --minify before last build | false | |
| hugo-cache-directory | Where to place the Hugo module cache, under the code-directory | true | hugo_cache
| hugo-env | Hugo environment (production, development, etc) | true | production |
| hugo-extended | Hugo Extended | true | true |
| hugo-version | Hugo Version | true | 'latest' |
| image-formats | Image formats to include in resource hash key | true | ['webp', 'svg', 'png', 'jpg', 'jpeg','gif', 'tiff', 'tif', 'bmp'] |
| include-drafts-audit | Build with `--buildDrafts` during audit | true | true |
| include-future-audit | Build with `--buildFuture` during audit | true | true |
| include-drafts-artifact | Build with `--buildDrafts` when building for another stage (generating an artifact) | true | false |
| include-future-artifact | Build with `--buildFuture`when building for another stage (generating an artifact) | true | false |
| output-directory | Location of the site output by Hugo, relative to the workspace | true | public |
| repo-directory | Where to checkout the repo, under the code-directory | true | repo |
| source-directory | Where the source for the site lives, within the repo | false | |
| upload-site-as | Artifact to create containing the Hugo site | false | |
| upload-site-filename | Filename for tarball of site to upload to artifact | true | hugo-site.tar |
| upload-site-retention | Retention period in days for Hugo site artifact | true | 1 |
| use-lfs | Use LFS when checking out out repo | true | false |

### Action outputs variables

None

### Sample usage

#### Single hugo.toml

```yaml
name: test-build-on-pr
on:
  pull_request:
    types:
    - assigned
    - opened
    - synchronize
    - reopened
  push:
    branches:
    - main
jobs:
  build-unminified-site:
    runs-on: ubuntu-22.04
    steps:
     - name: "Build site with Hugo and audit"
       uses: wildtechgarden/audit-build-action-hugo
       with:
         base-url: https://www.example.com/
         build-for-downstream: "true"
         use-lfs: true
 ```

#### With an extra configuration file

Create `hugo.toml` as usual, except put all site-wide parameters in
`config-params.toml` (beside `hugo.toml` in the directory structure;
includes `[params]` top-level key).

This can be useful for passing information into the build (e.g. for unit
tests).

```yaml
name: test-build-on-pr
on:
  pull_request:
    types:
    - assigned
    - opened
    - synchronize
    - reopened
  push:
    branches:
    - main
jobs:
  build-unminified-site:
    runs-on: ubuntu-22.04
    steps:
    - name: "Build site with Hugo and audit"
      uses: wildtechgarden/audit-build-action-hugo
      with:
        base-url: https://www.example.com/
        build-for-downstream: "true"
        config-file: hugo.toml,hugo.params.toml
        use-lfs: true
```

## Development

TBD

-------

## Colophon

Copyright © 2023 Wild Tech 'Garden'  
[Released under an MIT License](LICENSE)
