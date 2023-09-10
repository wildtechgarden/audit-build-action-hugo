# Module nouveau á l'Hugo au Wild Tech 'Garden'

Décrit: Créer un site Web Hugo et [auditer les erreurs
  silencieuses](https://discourse.gohugo.io/t/audit-your-published-site-for-problems/35184/8).
  Éventuellement, générer une sortie et/ou une utilisation d'artefact ou en
  d'autres tâches.
URL du référentiel: <https://github.com/wildtechgarden/audit-build-action-hugo>\
Site: <https://www.audit-build-action-default.wtg-demos.ca>\
Statut IC: [![pre-commit.ci statut](https://results.pre-commit.ci/badge/github/wildtechgarden/audit-build-action-hugo/main.svg)](https://results.pre-commit.ci/latest/github/wildtechgarden/audit-build-action-hugo/main)
[![test-build-audit](https://github.com/wildtechgarden/audit-build-action-hugo/actions/workflows/test-build-audit.yml/badge.svg)](https://github.com/wildtechgarden/audit-build-action-hugo/actions/workflows/test-build-audit.yml)

## Matières

1. [Matières](#matières)
2. [Configuration and Utilisation](#configuration-and-utilisation)
  1. [Action inputs variables](#action-inputs-variables)
  2. [Action outputs variables](#action-outputs-variables)
  3. [Sample usage](#sample-usage)
    1. [Single hugo.toml](#single-hugotoml)
    2. [With an extra configuration file](#with-an-extra-configuration-file)
3. [Développement](#développement)
4. [Colophon](#colophon)

## Configuration and Utilisation

### Action inputs variables

| Input | Description | Required | Default |
|-------|-------------|-------|---------|
| base-url | définir baseURL due site | false | |
| build-for-downstream | Créer à utilisation d'un autre tache sans artefact (string: "true" or "false" | true | "false" |
| checkout-fetch-depth | Cherche depth (recommander utilisant 0 to fetch all history si utilisant .GitInfo or .Lastmod) | true | 0 |
| checkout-submodules | Chercher git submodules: false, true, or recursive | true | false |
| code-directory | Location des modules et référentiel | true | ${{ github.workspace }}/code |
| config-file | Hugo configuration ficher (peu t'être une list sépare des virgules, relatif aux 'source') | true | "config.toml" |
| do-minify-audit | Si présente, utiliser --minify avant que auditer | false | |
| do-minify-bundle | Si présente, utiliser --minify avant que dernier créer | false | |
| hugo-cache-directory | Location de Hugo module cache, sous le `code-directory` | true | hugo_cache
| hugo-env | Hugo environnement (production, development, etc) | true | production |
| hugo-extended | Hugo Extended | true | true |
| hugo-version | Hugo Version | true | 'latest' |
| image-formats | Image formats aux resource hash key | true | ['webp', 'svg', 'png', 'jpg', 'jpeg','gif', 'tiff', 'tif', 'bmp'] |
| include-drafts-audit | Créer avec `--buildDrafts` pendant audit | true | true |
| include-future-audit | Créer avec `--buildFuture` pendant audit | true | true |
| include-drafts-artifact | Créer avec `--buildDrafts` pendant créer aux des autres taches  | true | false |
| include-future-artifact | Créer avec `--buildFuture` pendant créer aux des autres taches | true | false |
| output-directory | Location d'output de Hugo, relatif a workspace | true | public |
| repo-directory | Location de checkout aux référentiel, sous le code-directory | true | repo |
| source-directory | Location de source de site, dan le référentiel | false | |
| upload-site-as | Artefact a créer avec le site d'Hugo | false | |
| upload-site-filename | Nom de ficher a tarball de site aux artefact | true | hugo-site.tar |
| upload-site-retention | Jours de retention aux artefact de site d'Hugo | true | 1 |
| use-lfs | Utiliser LFS | true | false |

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

Utilise `hugo.toml` comme d'abord, mais donner les parameter du site
dans `config-params.toml` (à côté de `hugo.toml` ; avec `[params]` key en haute).

Cela peut être utile pour transmettre des informations dans la version.

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
    - name: "Créer un site Web Hugo et auditer"
      uses: wildtechgarden/audit-build-action-hugo
      with:
        base-url: https://www.example.com/
        build-for-downstream: "true"
        config-file: hugo.toml,hugo.params.toml
        use-lfs: true
```

## Développement

TBD

-------

## Colophon

Copyright © 2023 Wild Tech 'Garden'  
[Publié sous license MIT](LICENSE)
