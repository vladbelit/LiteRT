#!/usr/bin/env bash
set -ex

# Run this script under the root directory.
export TF_LOCAL_SOURCE_PATH=${TF_LOCAL_SOURCE_PATH:-"$(pwd)/third_party/tensorflow"}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/utils/utils.sh"

HOST_OS="$(get_os)" # linux/macos/windows
ARCH="$(uname -m)"
TENSORFLOW_TARGET=${TENSORFLOW_TARGET:-$1}
if [ "${TENSORFLOW_TARGET}" = "rpi" ]; then
  export TENSORFLOW_TARGET="armhf"
fi

# Build python interpreter_wrapper.
case "${TENSORFLOW_TARGET}" in
  armhf)
    BAZEL_FLAGS="--config=elinux_armhf
      --copt=-march=armv7-a --copt=-mfpu=neon-vfpv4
      --copt=-O3 --copt=-fno-tree-pre --copt=-fpermissive
      --define tensorflow_mkldnn_contraction_kernel=0
      --define=raspberry_pi_with_neon=true
      --config=use_local_tf
      --repo_env=USE_PYWRAP_RULES=True"
    ;;
  rpi0)
    BAZEL_FLAGS="--config=elinux_armhf
      --copt=-march=armv6 -mfpu=vfp -mfloat-abi=hard
      --copt=-O3 --copt=-fno-tree-pre --copt=-fpermissivec
      --define tensorflow_mkldnn_contraction_kernel=0
      --define=raspberry_pi_with_neon=true
      --config=use_local_tf
      --repo_env=USE_PYWRAP_RULES=True"
    ;;
  aarch64)
    BAZEL_FLAGS="--config=release_arm64_linux
      --define tensorflow_mkldnn_contraction_kernel=0
      --copt=-O3
      --config=use_local_tf
      --repo_env=USE_PYWRAP_RULES=True"
    ;;
  native)
    BAZEL_FLAGS="--copt=-O3
      --copt=-march=native
      --config=use_local_tf
      --repo_env=USE_PYWRAP_RULES=True"
    ;;
  windows)
    BAZEL_FLAGS="--copt=/O3 --host_copt=/O3"
    ;;
  windows)
    BAZEL_FLAGS="--copt=/O3 --host_copt=/O3"
    ;;
  *)
    BAZEL_FLAGS="--copt=-O3
      --config=use_local_tf
      --repo_env=USE_PYWRAP_RULES=True"
    ;;
esac

BAZEL_COMMON_FLAGS="--config=use_local_tf"
BAZEL_FLAGS="${BAZEL_FLAGS} ${BAZEL_COMMON_FLAGS}"

if [[ -n "${BAZEL_CONFIG_FLAGS}" ]]; then
  BAZEL_FLAGS="${BAZEL_FLAGS} ${BAZEL_CONFIG_FLAGS}"
fi

if [ -n "${NIGHTLY_RELEASE_DATE}" ]; then
  BAZEL_FLAGS="${BAZEL_FLAGS} --//ci/tools/python/wheel:nightly_iso_date=${NIGHTLY_RELEASE_DATE}"
fi

# Set linkopt for arm64 architecture, remote_cache for x86_64, and compiler for Win.
case "${ARCH}" in
  x86_64)
    if [ "${HOST_OS}" = "windows" ]; then
      BAZEL_FLAGS="${BAZEL_FLAGS} --compiler=clang-cl"
    fi
    ;;
  arm64)
    BAZEL_FLAGS="${BAZEL_FLAGS} --linkopt="-ld_classic""
    ;;
  aarch64)
    ;;
  *)
    echo "Unsupported architecture: ${ARCH} on ${HOST_OS}"
    exit 1
    ;;
esac

bazel ${BAZEL_STARTUP_OPTIONS} build -c opt --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //ci/tools/python/wheel:litert_wheel

# Move the wheel file to the root directory since it is not accessible from the
# bazel output directory to anyone other than the root user.
rm -fr ./dist
mkdir -p dist/
mv bazel-bin/ci/tools/python/wheel/dist/*.whl dist/

echo "Output can be found here:"
find "./dist/"

if [ "${TEST_MANYLINUX_COMPLIANCE}" = "true" ]; then
  echo "Testing manylinux compliance..."
  bazel ${BAZEL_STARTUP_OPTIONS} test -c opt --config=monolithic --config=nogcp --config=nonccl \
    ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //ci/tools/python/wheel:manylinux_compliance_test
fi

# Vendor SDKs

## Qualcomm SDK
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //ci/tools/python/vendor_sdk/qualcomm:ai_edge_litert_sdk_qualcomm_sdist

mv bazel-bin/ci/tools/python/vendor_sdk/qualcomm/ai_edge_litert_sdk_qualcomm*.tar.gz dist/

## Mediatek SDK
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //ci/tools/python/vendor_sdk/mediatek:ai_edge_litert_sdk_mediatek_sdist

mv bazel-bin/ci/tools/python/vendor_sdk/mediatek/ai_edge_litert_sdk_mediatek*.tar.gz dist/

echo "Output found here:"
/usr/bin/find "./dist/"
