# pyo3-bazel

This is an example repository to build python bindings of rust (PyO3) using Bazel.

```console
bazel run //python-cmd
```

## Development

### Rust

Update BUILD.bazel by Cargo.toml
Run this command every time you update Cargo.toml.

```console
bazel run @cargo_raze//:raze -- --manifest-path=$(realpath Cargo.toml)
```

### Golang

Update BUILD.bazel of Golang with the following command:

```console
bazel run @go_sdk//:bin/go -- mod tidy
bazel run //:gazelle
bazel run //:gazelle-update-repos
```
