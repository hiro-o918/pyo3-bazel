# pyo3-bazel

## Requirements

-   [bazel](https://bazel.build/) or [bazelisk](https://github.com/bazelbuild/bazelisk)
    -   bazelisk is recommended
-   [poetry](https://python-poetry.org/docs/): development only
-   [protoc](https://grpc.io/docs/protoc-installation/): development only
    -   [prost_build] of Rust depends on protoc binary, so to use rust-analyzer on development, you need to install protoc
-   Xcode (only macOS): for build LightGBM with cmake

    -   Some C++ headers can not be found on binding generation without Xcode
    -   After installing Xcode, you can check configurations by the below command.

    ```console
    sudo xcodebuild -license
    # Check gcc configured with prefix of Xcode not CommandLineTools
    gcc --version
    > Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr --with-gxx-include-dir=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/4.2.1
    > Apple clang version 13.0.0 (clang-1300.0.29.30)
    > Target: x86_64-apple-darwin20.6.0
    > Thread model: posix
    > InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
    ```

-   [lightgbm-rs dependencies](https://github.com/vaaaaanquish/lightgbm-rs#require)

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
