i#!/bin/bash
set -ex
# Run this script under the root directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PYTHON="python3"
VERSION_SUFFIX=""
export TENSORFLOW_DIR="./third_party/tensorflow"
TENSORFLOW_LITE_DIR="./tflite"
ARCH="x86_64"
CUSTOM_BAZEL_FLAGS="--config=release_cpu_windows"
export PACKAGE_VERSION="1.1.2"
export PROJECT_NAME="ai_edge_litert"
BUILD_DIR="${TENSORFLOW_LITE_DIR}/gen/litert_pip/python3"
# Explicitly set for Windows
TENSORFLOW_TARGET="windows"
export CROSSTOOL_PYTHON_INCLUDE_PATH=$(${PYTHON} -c "from sysconfig import get_paths as gp; print(gp()['include'])")

# Build source tree.
rm -rf "${BUILD_DIR}" && mkdir -p "${BUILD_DIR}/ai_edge_litert"
cp -r "${TENSORFLOW_LITE_DIR}/tools/pip_package/debian" \
      "${TENSORFLOW_LITE_DIR}/tools/pip_package/MANIFEST.in" \
      "${TENSORFLOW_LITE_DIR}/python/interpreter_wrapper" \
      "${BUILD_DIR}"
cp  "${SCRIPT_DIR}/setup_with_binary.py" "${BUILD_DIR}/setup.py"
cp "${TENSORFLOW_LITE_DIR}/python/interpreter.py" \
   "${TENSORFLOW_LITE_DIR}/python/metrics/metrics_interface.py" \
   "${TENSORFLOW_LITE_DIR}/python/metrics/metrics_portable.py" \
   "${BUILD_DIR}/ai_edge_litert"

# Replace package name.
sed -i -e 's/tflite_runtime/ai_edge_litert/g' "${BUILD_DIR}/ai_edge_litert/interpreter.py"
sed -i -e 's/tflite_runtime/ai_edge_litert/g' "${BUILD_DIR}/ai_edge_litert/metrics_portable.py"
echo "__version__ = '${PACKAGE_VERSION}'" >> "${BUILD_DIR}/ai_edge_litert/__init__.py"
echo "__git_version__ = '$(git -C "${TENSORFLOW_DIR}" describe)'" >> "${BUILD_DIR}/ai_edge_litert/__init__.py"

# Set Windows-specific flags
BAZEL_FLAGS="--copt=-O3"
LIBRARY_EXTENSION=".pyd"

# We need to pass down the environment variable with a possible alternate Python
# include path for Python 3.x builds to work.
export CROSSTOOL_PYTHON_INCLUDE_PATH

# Build Python interpreter wrapper
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt -s --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //tflite/python/interpreter_wrapper:_pywrap_tensorflow_interpreter_wrapper
cp "bazel-bin/tflite/python/interpreter_wrapper/_pywrap_tensorflow_interpreter_wrapper${LIBRARY_EXTENSION}" \
   "${BUILD_DIR}/ai_edge_litert"

# Build and add GenAI Ops library into the package.
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt -s --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //tflite/experimental/genai:pywrap_genai_ops
cp "bazel-bin/tflite/experimental/genai/pywrap_genai_ops${LIBRARY_EXTENSION}" \
   "${BUILD_DIR}/ai_edge_litert"

# Build schema
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt -s --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //tflite/python:schema_py
cp "bazel-bin/tflite/python/schema_py_generated.py" \
   "${BUILD_DIR}/ai_edge_litert"

# Build and add profiling protos to the package.
bazel ${BAZEL_STARTUP_OPTIONS} build -c opt -s --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //tflite/profiling/proto:profiling_info_py
cp "bazel-bin/tflite/profiling/proto/profiling_info_pb2.py" \
   "${BUILD_DIR}/ai_edge_litert"

bazel ${BAZEL_STARTUP_OPTIONS} build -c opt -s --config=monolithic --config=nogcp --config=nonccl \
  ${BAZEL_FLAGS} ${CUSTOM_BAZEL_FLAGS} //tflite/profiling/proto:model_runtime_info_py
cp "bazel-bin/tflite/profiling/proto/model_runtime_info_pb2.py" \
   "${BUILD_DIR}/ai_edge_litert"

# Rename the namespace in the generated proto files to ai_edge_litert.
# This is required to maintain dependency between the two protos.
sed -i -e 's/tflite\.profiling\.proto/ai_edge_litert/g' "${BUILD_DIR}/ai_edge_litert/model_runtime_info_pb2.py"

# Ensure proper permissions
chmod u+w "${BUILD_DIR}/ai_edge_litert/_pywrap_tensorflow_interpreter_wrapper${LIBRARY_EXTENSION}"
chmod u+w "${BUILD_DIR}/ai_edge_litert/pywrap_genai_ops${LIBRARY_EXTENSION}"

# Build python wheel - specifically for Windows
pushd "${BUILD_DIR}"
# For Windows, we'll let setuptools determine the platform tag
${PYTHON} setup.py bdist_wheel
popd

echo "Output can be found here:"
find "${BUILD_DIR}/dist"
