#!/bin/bash

set -e
set -o pipefail

if [ -s .hvm ]; then
	HUGO_COMMAND="$(cat .hvm)"
fi

[ -z "$HUGO_COMMAND" ] && HUGO_COMMAND="hugo"

if [ -z "${HUGO_CACHEDIR}" ]; then
	HUGO_CACHEDIR="$(pwd)/hugo-cache"
fi

export SITECONFIG="$(pwd)"/tests/config/hugo.toml,"$(pwd)"/tests/config/variations/config-default.toml,"$(pwd)"/tests/config/variations/config-latest.toml

export HUGO_MODULE_REPLACEMENTS="github.com/wildtechgarden/audit-build-action-hugo -> $(pwd)"
export HUGO_RESOURCEDIR="$(pwd)/resources"
export SITEROOT="$(pwd)"
cd tests/config && "${HUGO_COMMAND}" serve --buildDrafts --buildFuture --source "${SITEROOT}" --environment "${HUGO_ENV:-development}" --config "${SITECONFIG}"
