$Env:HUGO_RESOURCEDIR="$PWD\resources"
hugo.exe  serve --buildDrafts --buildFuture --environment "development" --config '$PWD\config.toml'
