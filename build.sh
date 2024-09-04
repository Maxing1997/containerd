#!/bin/bash
set -e
set -x

# use go 1.22
./script/setup/install-protobuf
HOSTARCH=$(go env GOHOSTARCH)
export GOARCH=${HOSTARCH}

case ${ARCH} in
  aarch64)
    export GOARCH=arm64
    ;;
  *)
    export GOARCH=amd64
    ;;
esac

GOOS=$(go env GOOS)
debug_env=${IS_DEBUG_ENV:-True}

cur_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd "${cur_dir}"
install_dir="${cur_dir}/output"
rm -rf "${install_dir}"
mkdir -p "${install_dir}"

export GODEBUG=true && make BUILDTAGS="no_aufs no_btrfs no_devmapper no_zfs"
cp -fp bin/* "${install_dir}"
popd

