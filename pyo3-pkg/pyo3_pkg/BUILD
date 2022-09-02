load("@rules_python//python:defs.bzl", "py_library")
load(":python_lib.bzl", "symlink_python_lib")

symlink_python_lib(
    name = "pyo3-pkg-symlink",
    pkg_name="pyo3_pkg",
    src = "//pyo3-pkg:pyo3-pkg",
)

filegroup(
    name = "pyo3-pkg",
    srcs = [
        "__init__.py",
        ":pyo3-pkg-symlink",
    ],
    visibility = ["//visibility:private"],
)

py_library(
    name = "pyo3_pkg",
    data = [
        ":pyo3-pkg"
    ],
    imports = ["."],
    visibility = ["//visibility:public"],
)
