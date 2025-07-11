# Copyright 2025 Google LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package(
    # copybara:uncomment default_applicable_licenses = ["@org_tensorflow//tensorflow:license"],
    default_visibility = ["//litert:litert_public"],
)

cc_library(
    name = "litert_cpu_options",
    srcs = ["litert_cpu_options.cc"],
    hdrs = ["litert_cpu_options.h"],
    deps = [
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_macros",
        "//litert/runtime:litert_cpu_options",
        "//tflite/delegates/xnnpack:xnnpack_delegate",
    ],
)

cc_test(
    name = "litert_cpu_options_test",
    srcs = ["litert_cpu_options_test.cc"],
    deps = [
        ":litert_cpu_options",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_macros",
        "//litert/test:matchers",
        "@com_google_absl//absl/cleanup",
        "@com_google_absl//absl/strings:string_view",
        "@com_google_googletest//:gtest_main",
    ],
)

# QUALCOMM #########################################################################################

cc_library(
    name = "litert_qualcomm_options",
    srcs = ["litert_qualcomm_options.cc"],
    hdrs = ["litert_qualcomm_options.h"],
    deps = [
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_detail",
        "//litert/cc:litert_expected",
        "//litert/cc:litert_handle",
        "//litert/cc:litert_macros",
        "//litert/cc:litert_opaque_options",
        "@com_google_absl//absl/strings:string_view",
    ],
)

cc_test(
    name = "litert_qualcomm_options_test",
    srcs = ["litert_qualcomm_options_test.cc"],
    deps = [
        ":litert_qualcomm_options",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_opaque_options",
        "//litert/cc/options:litert_qualcomm_options",
        "//litert/test:matchers",
        "@com_google_googletest//:gtest_main",
    ],
)

# GOOGLE TENSOR ####################################################################################

cc_library(
    name = "litert_google_tensor_options",
    srcs = ["litert_google_tensor_options.cc"],
    hdrs = ["litert_google_tensor_options.h"],
    deps = [
        ":litert_google_tensor_options_type",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_detail",
        "//litert/cc:litert_expected",
        "//litert/cc:litert_handle",
        "//litert/cc:litert_macros",
        "//litert/cc:litert_opaque_options",
        "//litert/runtime:litert_google_tensor",
        "@com_google_absl//absl/strings:string_view",
    ],
)

cc_test(
    name = "litert_google_tensor_options_test",
    srcs = ["litert_google_tensor_options_test.cc"],
    deps = [
        ":litert_google_tensor_options",
        "//litert/c:litert_opaque_options",
        "//litert/cc/options:litert_google_tensor_options",
        "//litert/test:matchers",
        "@com_google_googletest//:gtest_main",
    ],
)

# MEDIATEK ####################################################################################

cc_library(
    name = "litert_mediatek_options",
    srcs = ["litert_mediatek_options.cc"],
    hdrs = ["litert_mediatek_options.h"],
    deps = [
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_detail",
        "//litert/cc:litert_expected",
        "//litert/cc:litert_handle",
        "//litert/cc:litert_macros",
        "//litert/cc:litert_opaque_options",
        "@com_google_absl//absl/strings:string_view",
    ],
)

cc_library(
    name = "litert_gpu_options",
    srcs = ["litert_gpu_options.cc"],
    hdrs = ["litert_gpu_options.h"],
    deps = [
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_expected",
        "//litert/cc:litert_macros",
        "@com_google_absl//absl/strings:string_view",
    ],
)

cc_library(
    name = "litert_runtime_options",
    srcs = ["litert_runtime_options.cc"],
    hdrs = ["litert_runtime_options.h"],
    deps = [
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_macros",
        "//litert/runtime:litert_runtime_options",
    ],
)

cc_library(
    name = "litert_google_tensor_options_type",
    hdrs = ["litert_google_tensor_options_type.h"],
)

cc_test(
    name = "litert_runtime_options_test",
    srcs = ["litert_runtime_options_test.cc"],
    deps = [
        ":litert_runtime_options",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc:litert_macros",
        "//litert/test:matchers",
        "@com_google_absl//absl/cleanup",
        "@com_google_absl//absl/strings:string_view",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "litert_mediatek_options_test",
    srcs = ["litert_mediatek_options_test.cc"],
    deps = [
        ":litert_mediatek_options",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/cc/options:litert_mediatek_options",
        "//litert/test:matchers",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "litert_gpu_options_test",
    srcs = ["litert_gpu_options_test.cc"],
    deps = [
        ":litert_gpu_options",
        "//litert/c:litert_common",
        "//litert/c:litert_opaque_options",
        "//litert/test:matchers",
        "@com_google_googletest//:gtest_main",
    ],
)

filegroup(
    name = "options_headers",
    srcs = glob(["litert_*.h"]),
    visibility = ["//litert/c:__pkg__"],
)
