#!/bin/bash

set -e
set -o pipefail

SITEROOT="$(pwd)"

export HUGO_MODULE_REPLACEMENTS="github.com/wildtechgarden/wild-theme-shell-mod-hugo -> $(pwd)/../wild-theme-shell-mod-hugo, github.com/wildtechgarden/a-wild-theme-mod-hugo -> $(pwd)/../a-wild-theme-mod-hugo, github.com/wildtechgarden/demo-test-site-hugo-wtg -> $(pwd)/../wild-demo-test-site-hugo-wtg, github.com/wildtechgarden/module-starter-hugo-wtg -> $(pwd)/../module-starter-hugo-wtg, github.com/wildtechgarden/minimal-test-theme-hugo-wtg -> $(pwd)/../minimal-test-theme-hugo-wtg"
systemd-run --working-dir "$(pwd)/tests/config" -E PATH="${PATH}" -E HUGO_RESOURCEDIR="$(pwd)"/resources -E HUGO_MODULE_REPLACEMENTS="$HUGO_MODULE_REPLACEMENTS" --unit=hugo-serve --user hugo serve --source "$(pwd)" --environment "production" --config "$(pwd)"/tests/config/hugo.toml --port 1313 --bind 127.0.0.1

sleep 2

if muffet http://127.0.0.1:1313/ | tee check-links.log; then
	echo "ok"
	RET=0
else
	echo "not ok"
	RET=1
fi

systemctl --user stop hugo-serve
exit $RET
