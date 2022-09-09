# pyo3-bazel

## Requirements

-   [poetry](https://python-poetry.org/docs/)
-   [bazel](https://bazel.build/) or [bazelisk](https://github.com/bazelbuild/bazelisk)
    -   bazelisk is recommended

This is an example repository to build python bindings of rust (PyO3) using Bazel.

## Production Targets

### Run script using FFI of Go and Rust

```console
bazel run //python-cmd
```

### Build wheel a package including archives

```console
bazel build //pythonlib:pythonlib_wheel
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

### Python

Check the [README.md](python/README.md) for more information.

## Projects

### golib

Go Library

TODO: Write more

### pythonlib

Python library

#### Run Test

Run pytest ob pythonlib

```console
bazel test //pythonlib:pytest
```

## Format and Lint

### Format

Format packages with the following command:

```console
bazel query "attr(tags, '\\bformat\\b', //...)" | xargs -I{} bazel run {}
```

### Lint

Lint packages with the following command:

```console
bazel test //... --test_tag_filters lint
```
