#!/bin/bash
# cspell:ignore auditdefault

set -e
set -o pipefail

rm -rf public

export BASEURL="https://www.audit-build-action-default.wtg-demos.ca/"
export HUGO_RESOURCEDIR="$(pwd)"/resources
export SITECONFIG="$(pwd)"/tests/config/hugo.toml,"$(pwd)"/tests/config/variations/config-default.toml,"$(pwd)"/tests/config/variations/config-latest.toml
export TARGET="$(pwd)"/public
export CURDIR="$(pwd)"

cd tests/config && hugo --gc --minify -b $BASEURL --source "${CURDIR}/tests/config" --destination "${TARGET}" --config "${SITECONFIG}"
cd "${CURDIR}"
rclone sync --progress --checksum public/ wtg-auditdefault:./
