# Copyright 2025 The AI Edge LiteRT Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

licenses(["restricted"])

package(default_visibility = ["//visibility:public"])

java_runtime(
    name = "windows_jdk8",
    srcs = [],
    java_home = "C:/openjdk",
)

# -------------------- PLATFORMS --------------------

# An RBE-compatible platform
platform(
    name = "x64_windows-clang-cl",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@bazel_tools//tools/cpp:clang-cl",
    ],
    remote_execution_properties = """
        properties:{
          name: "container-image"
	  value: "docker://gcr.io/tensorflow-testing/tf-win2022@sha256:915cb093630432c38b028f56bd31116a5559ebbc688d427b6092d86828ae03bc"
        }
        properties:{
          name: "OSFamily"
          value: "Windows"
        }
        properties:{
          name: "Pool" value: "win2022"
        }
        properties:{
          name: "dockerNetwork" value: "off"
        }
        """,
)

# ----------------- CONFIG SETTINGS -----------------

config_setting(
    name = "is_windows_x64_clang_cl",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
        "@bazel_tools//tools/cpp:clang-cl",
    ],
)
