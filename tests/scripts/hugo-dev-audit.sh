#!/bin/bash

set -e
set -o pipefail

[ -z "$HUGO_COMMAND" ] && HUGO_COMMAND="hugo"

if [ -z "$SITEROOT" ]; then
	SITEROOT="$(pwd)"
fi

if [ -n "$SITECONFIG" ]; then
	SITECONFIG="--config ""$SITECONFIG"
else
	SITECONFIG="--config ""$(pwd)"/tests/config/hugo.toml
fi

if [ -z "${HUGO_CACHEDIR}" ]; then
	HUGO_CACHEDIR="$(pwd)/hugo-cache"
fi
export HUGO_CACHEDIR

rm -rf "${SITEROOT}/public"

echo "Building for audit in ${SITEROOT}/public for environment ${HUGO_ENV:-development}"

export HUGO_MODULE_REPLACEMENTS="github.com/wildtechgarden/wild-theme-shell-mod-hugo -> $(pwd)/../wild-theme-shell-mod-hugo, github.com/wildtechgarden/a-wild-theme-mod-hugo -> $(pwd)/../a-wild-theme-mod-hugo, github.com/wildtechgarden/demo-test-site-hugo-wtg -> $(pwd)/../wild-demo-test-site-hugo-wtg, github.com/wildtechgarden/module-starter-hugo-wtg -> $(pwd)/../module-starter-hugo-wtg, github.com/wildtechgarden/minimal-test-theme-hugo-wtg -> $(pwd)/../minimal-test-theme-hugo-wtg"
export HUGO_RESOURCEDIR="$(pwd)/resources"

# shellcheck disable=2086
if cd tests/config && HUGO_MINIFY_TDEWOLFF_HTML_KEEPCOMMENTS=true HUGO_ENABLEMISSINGTRANSLATIONPLACEHOLDERS=true "$HUGO_COMMAND" $SITECONFIG --gc --buildDrafts --buildFuture --source "${SITEROOT}" --destination "${SITEROOT}/public" --environment "${HUGO_ENV:-development}" ${BASEURL:+-b $BASEURL} && [ -s "${SITEROOT}/public/index.html" ]; then
	# If hugo build succeeds, it is possible audit issues are present, check further
	# Check for problem indicators (see https://discourse.gohugo.io/t/audit-your-published-site-for-problems/35184)
	set +e
	grep -iIrnE '<\!-- raw HTML omitted -->|ZgotmplZ|hahahugo|\[i18n\]|\(<nil>\)|\(&lt;nil&gt;\)' "${SITEROOT}/public/" >hugo-audit.log
	RET=$?
	set -e
	if [ "$RET" != "1" ] && [ "$RET" != "0" ]; then
		# Make sure we fail if there is is error executing the check command
		echo "not ok"
		exit 1
	fi

	# Check if problem indicators are part of some page's content (e.g. a page describing how
	# to check for Hugo audit issues).
	if [ "$RET" = "0" ] && [ -s hugo-audit.log ]; then
		set +e
		grep -iIvE 'grep.+((-- raw HTML omitted --|ZgotmplZ|hahahugo|\\\[i18n\\\]|\\\(<nil>\\\)|\\\(&lt;nil&gt;\\\)).*)+' hugo-audit.log
		RET2=$?
		set -e
		if [ "$RET2" != "1" ]; then
			# Make sure we fail if there is an error executing the false positive elimination command (exit code 2)
			# Also fail if there was a true positive (exit code 0)
			echo "not ok"
			exit 1
		fi
	fi
	rm -rf "${SITEROOT}/public"
	echo "Building unminified site for checks in ${SITEROOT}/public for environment ${HUGO_ENV:-development}"
	# Build unminified site without audit-only information
	if HUGO_MINIFY_TDEWOLFF_HTML_KEEPCOMMENTS=false HUGO_ENABLEMISSINGTRANSLATIONPLACEHOLDERS=false "$HUGO_COMMAND" $SITECONFIG --gc --buildDrafts --buildFuture --source "${SITEROOT}" --destination "${SITEROOT}"/public --environment "${HUGO_ENV:-development}" ${BASEURL:+-b $BASEURL} >hugo-build-unminified.log; then
		if [ -s "${SITEROOT}/public/index.html" ]; then
			set +e
			grep -InE '(WARN [0-9:/\ ]+ FAIL: )' hugo-build-unminified.log
			RET3=$?
			set -e
			if [ "$RET3" = "0" ]; then
				echo "not ok"
				exit 1
			fi
		else
			echo "not ok"
			exit 1
		fi
		echo "ok"
		exit 0
	else
		# If Hugo build fails, audit fails
		echo "not ok"
		exit 1
	fi
else
	# If Hugo build fails, audit fails
	echo "not ok"
	exit 1
fi
