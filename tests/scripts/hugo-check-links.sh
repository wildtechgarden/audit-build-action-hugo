#!/bin/bash

set -e
set -o pipefail

SITEROOT="$(pwd)"

export HUGO_MODULE_REPLACEMENTS="github.com/wildtechgarden/audit-build-action-hugo -> $(pwd)"
systemd-run --working-dir "$(pwd)/tests/config" -E PATH="${PATH}" -E HUGO_RESOURCEDIR="$(pwd)"/resources -E HUGO_MODULE_REPLACEMENTS="$HUGO_MODULE_REPLACEMENTS" --unit=hugo-serve --user hugo serve --source "$(pwd)" --environment "production" --config "$(pwd)"/tests/config/hugo.toml --port 1313 --bind 127.0.0.1

sleep 5

if muffet http://127.0.0.1:1313/ | tee check-links.log; then
	echo "ok"
	RET=0
else
	echo "not ok"
	RET=1
fi

systemctl --user stop hugo-serve
exit $RET
