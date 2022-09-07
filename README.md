# pyo3-bazel

This is an example repository to build python bindings of rust (PyO3) using Bazel.

```console
bazel run //python-cmd
```

## Development

### Rust

Update BUILD.bazel by Cargo.toml
Run this command every time you update Cargo.toml.

#### [Update Dependencies](https://bazelbuild.github.io/rules_rust/crate_universe.html#repinning--updating-dependencies)

```console
CARGO_BAZEL_REPIN=1 bazel sync --only=crate_index
```

#### [Create Config for Rust Analyzer](https://bazelbuild.github.io/rules_rust/rust_analyzer.html)

```console
bazel run @rules_rust//tools/rust_analyzer:gen_rust_project
```

### Golang

Update BUILD.bazel of Golang with the following command:

```console
bazel run @go_sdk//:bin/go -- mod tidy
bazel run //:gazelle
bazel run //:gazelle-update-repos
```
