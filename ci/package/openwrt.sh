#!/usr/bin/env bash
set -euo pipefail
cp -a source/src "recipes/$BUILD_PROJECT/src"
version=$(cat source/VERSION)
sed -e "s/@VERSION@/$version/g" -e "s/@REVISION@/$PACKAGE_RELEASE/g" source/ci/package/Makefile > "recipes/$BUILD_PROJECT/Makefile"
compile() {
    if [ "${GITHUB_RUN_ATTEMPT:-1}" = 1 ] && python3 - "$bundle" <<'CASCADE_FAILURE_WINDOW'
import json,os,sys
from pathlib import Path
context=json.loads((Path(sys.argv[1])/'context.json').read_text())
request=json.loads(os.environ['PACKAGE_REQUEST'])
sys.exit(0 if context.get('cause')=='dependent' and request['target']=='openwrt-24.10-x86_64' else 1)
CASCADE_FAILURE_WINDOW
    then
        printf 'D03/D04 sandbox fixture: hold the first in-cascade side attempt for 1200 seconds.\n'
        sleep 1200
        printf 'D06 sandbox fixture: first in-cascade side attempt fails; operator rerun bypasses the hold and failure.\n' >&2
        exit 42
    fi
    make -j"$(nproc)" "package/$BUILD_PROJECT/compile" V=s BUILD_LOG=1
    local target file
    local files=("recipes/$BUILD_PROJECT")
    target=$(echo staging_dir/target-*)
    if [ -f "$target/packages/$BUILD_PROJECT.list" ]; then
        while IFS= read -r file; do
            file="$target/${file#./}"
            if [ -f "$file" ] || [ -L "$file" ]; then
                files+=("$file")
            fi
        done < "$target/packages/$BUILD_PROJECT.list"
    fi
    if [ -f "$target/pkginfo/$BUILD_PROJECT.provides" ]; then
        files+=("$target/pkginfo/$BUILD_PROJECT.provides")
    fi
    printf 'Own development export: %s\n' "${files[@]}"
    python3 -m ci.repository sdk-export "$sdk" "$bundle" "${files[@]}"
    return 0
}
