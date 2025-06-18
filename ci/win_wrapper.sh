set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Simply so that `set -u` doesn't throw
export TENSORFLOW_TARGET=windows
export BAZEL_CONFIG_FLAGS=
export CUSTOM_BAZEL_FLAGS
export BAZEL_FLAGS=
export BAZEL_STARTUP_OPTIONS=

# shellcheck disable=SC2155
export NIGHTLY_RELEASE_DATE=$(TZ="America/Los_Angeles" date "+%Y%m%d")


DOCKER_PYTHON_VERSION="${DOCKER_PYTHON_VERSION:-3.11}"

export CI_BUILD_PYTHON="C:/python${DOCKER_PYTHON_VERSION}/python.exe"
export HERMETIC_PYTHON_VERSION="${DOCKER_PYTHON_VERSION}"

${CI_BUILD_PYTHON} -m pip install pip setuptools wheel

bash "${SCRIPT_DIR}/build_pip_package_with_bazel.sh"
