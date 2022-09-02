load("//cargo:crates.bzl", "crate_deps")
load("@rules_rust//rust:defs.bzl", "rust_shared_library")
load("@bazel_skylib//lib:selects.bzl", "selects")

rust_shared_library(
    name = "pyo3-pkg",
    srcs=["src/lib.rs"],
    rustc_flags = selects.with_or({
        (
            "@rules_rust//rust/platform:x86_64-apple-darwin",
            "@rules_rust//rust/platform:aarch64-apple-darwin",
        ): [
            "-Clink-arg=-undefined",
            "-Clink-arg=dynamic_lookup",
        ],
        "//conditions:default": [],
    }),
    visibility = [
        "//visibility:public",
    ],
    deps =  crate_deps([
        "pyo3",
    ])
)
