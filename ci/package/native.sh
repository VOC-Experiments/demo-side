#!/usr/bin/env bash
set -euo pipefail
apt-get install -y build-essential
version=$(cat "sources/$BUILD_PROJECT/VERSION")
version=$(python3 /work/feed/ci/repository.py package-version "$DISTRIBUTION" "$SUITE" "$version" "$PACKAGE_RELEASE")
staging=$(mktemp -d)
mkdir -p "$staging/DEBIAN" "$staging/usr/bin" "$staging/usr/lib" "$staging/usr/include"
gcc -fPIC -shared sources/demo-side/src/side.c -ldemo-core -Wl,-soname,libdemo-side.so -o "$staging/usr/lib/libdemo-side.so"
gcc sources/demo-side/src/side-main.c -L"$staging/usr/lib" -ldemo-side -o "$staging/usr/bin/demo-side"
cp sources/demo-side/src/side.h "$staging/usr/include/demo-side.h"
cat > "$staging/DEBIAN/control" <<EOF
Package: demo-side
Version: $version
Architecture: $ARCH
Maintainer: VOC Experiments <ci@example.invalid>
Description: Disposable canonical CI diamond arm
Depends: demo-core
EOF
dpkg-deb --root-owner-group --build "$staging" "packages/${BUILD_PROJECT}_${version}_${ARCH}.deb"
printf '%s\n' "$BUILD_PROJECT" > "packages/${BUILD_PROJECT}.packages"
