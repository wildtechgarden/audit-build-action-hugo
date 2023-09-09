#!/bin/bash

set -e
set -o pipefail

SITEROOT="$(pwd)"

if java -jar ~/jar/vnu.jar --Werror $(find ${SITEROOT}/public -name '*.html') | tee html-validate.log; then
	if java -jar ~/jar/vnu.jar --Werror --css $(find ${SITEROOT}/public -name '*.css') | tee -a html-validate.log; then
		echo "ok"
		exit 0
	else
		echo "not ok"
		exit 1
	fi
else
	echo "not ok"
	exit 1
fi
