"""
@generated
cargo-raze generated Bazel file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")  # buildifier: disable=load

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of normal dependencies for the Rust targets of that package.
_DEPENDENCIES = {
    "pyo3-pkg": {
        "pyo3": "@cargo__pyo3__0_17_1//:pyo3",
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of proc_macro dependencies for the Rust targets of that package.
_PROC_MACRO_DEPENDENCIES = {
    "pyo3-pkg": {
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of normal dev dependencies for the Rust targets of that package.
_DEV_DEPENDENCIES = {
    "pyo3-pkg": {
    },
}

# EXPERIMENTAL -- MAY CHANGE AT ANY TIME: A mapping of package names to a set of proc_macro dev dependencies for the Rust targets of that package.
_DEV_PROC_MACRO_DEPENDENCIES = {
    "pyo3-pkg": {
    },
}

def crate_deps(deps, package_name = None):
    """EXPERIMENTAL -- MAY CHANGE AT ANY TIME: Finds the fully qualified label of the requested crates for the package where this macro is called.

    WARNING: This macro is part of an expeirmental API and is subject to change.

    Args:
        deps (list): The desired list of crate targets.
        package_name (str, optional): The package name of the set of dependencies to look up.
            Defaults to `native.package_name()`.
    Returns:
        list: A list of labels to cargo-raze generated targets (str)
    """

    if not package_name:
        package_name = native.package_name()

    # Join both sets of dependencies
    dependencies = _flatten_dependency_maps([
        _DEPENDENCIES,
        _PROC_MACRO_DEPENDENCIES,
        _DEV_DEPENDENCIES,
        _DEV_PROC_MACRO_DEPENDENCIES,
    ])

    if not deps:
        return []

    missing_crates = []
    crate_targets = []
    for crate_target in deps:
        if crate_target not in dependencies[package_name]:
            missing_crates.append(crate_target)
        else:
            crate_targets.append(dependencies[package_name][crate_target])

    if missing_crates:
        fail("Could not find crates `{}` among dependencies of `{}`. Available dependencies were `{}`".format(
            missing_crates,
            package_name,
            dependencies[package_name],
        ))

    return crate_targets

def all_crate_deps(normal = False, normal_dev = False, proc_macro = False, proc_macro_dev = False, package_name = None):
    """EXPERIMENTAL -- MAY CHANGE AT ANY TIME: Finds the fully qualified label of all requested direct crate dependencies \
    for the package where this macro is called.

    If no parameters are set, all normal dependencies are returned. Setting any one flag will
    otherwise impact the contents of the returned list.

    Args:
        normal (bool, optional): If True, normal dependencies are included in the
            output list. Defaults to False.
        normal_dev (bool, optional): If True, normla dev dependencies will be
            included in the output list. Defaults to False.
        proc_macro (bool, optional): If True, proc_macro dependencies are included
            in the output list. Defaults to False.
        proc_macro_dev (bool, optional): If True, dev proc_macro dependencies are
            included in the output list. Defaults to False.
        package_name (str, optional): The package name of the set of dependencies to look up.
            Defaults to `native.package_name()`.

    Returns:
        list: A list of labels to cargo-raze generated targets (str)
    """

    if not package_name:
        package_name = native.package_name()

    # Determine the relevant maps to use
    all_dependency_maps = []
    if normal:
        all_dependency_maps.append(_DEPENDENCIES)
    if normal_dev:
        all_dependency_maps.append(_DEV_DEPENDENCIES)
    if proc_macro:
        all_dependency_maps.append(_PROC_MACRO_DEPENDENCIES)
    if proc_macro_dev:
        all_dependency_maps.append(_DEV_PROC_MACRO_DEPENDENCIES)

    # Default to always using normal dependencies
    if not all_dependency_maps:
        all_dependency_maps.append(_DEPENDENCIES)

    dependencies = _flatten_dependency_maps(all_dependency_maps)

    if not dependencies:
        return []

    return dependencies[package_name].values()

def _flatten_dependency_maps(all_dependency_maps):
    """Flatten a list of dependency maps into one dictionary.

    Dependency maps have the following structure:

    ```python
    DEPENDENCIES_MAP = {
        # The first key in the map is a Bazel package
        # name of the workspace this file is defined in.
        "package_name": {

            # An alias to a crate target.     # The label of the crate target the
            # Aliases are only crate names.   # alias refers to.
            "alias":                          "@full//:label",
        }
    }
    ```

    Args:
        all_dependency_maps (list): A list of dicts as described above

    Returns:
        dict: A dictionary as described above
    """
    dependencies = {}

    for dep_map in all_dependency_maps:
        for pkg_name in dep_map:
            if pkg_name not in dependencies:
                # Add a non-frozen dict to the collection of dependencies
                dependencies.setdefault(pkg_name, dict(dep_map[pkg_name].items()))
                continue

            duplicate_crate_aliases = [key for key in dependencies[pkg_name] if key in dep_map[pkg_name]]
            if duplicate_crate_aliases:
                fail("There should be no duplicate crate aliases: {}".format(duplicate_crate_aliases))

            dependencies[pkg_name].update(dep_map[pkg_name])

    return dependencies

def cargo_fetch_remote_crates():
    """This function defines a collection of repos and should be called in a WORKSPACE file"""
    maybe(
        http_archive,
        name = "cargo__autocfg__1_1_0",
        url = "https://crates.io/api/v1/crates/autocfg/1.1.0/download",
        type = "tar.gz",
        sha256 = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa",
        strip_prefix = "autocfg-1.1.0",
        build_file = Label("//cargo/remote:BUILD.autocfg-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__bitflags__1_3_2",
        url = "https://crates.io/api/v1/crates/bitflags/1.3.2/download",
        type = "tar.gz",
        sha256 = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a",
        strip_prefix = "bitflags-1.3.2",
        build_file = Label("//cargo/remote:BUILD.bitflags-1.3.2.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__cfg_if__1_0_0",
        url = "https://crates.io/api/v1/crates/cfg-if/1.0.0/download",
        type = "tar.gz",
        sha256 = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd",
        strip_prefix = "cfg-if-1.0.0",
        build_file = Label("//cargo/remote:BUILD.cfg-if-1.0.0.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__indoc__1_0_7",
        url = "https://crates.io/api/v1/crates/indoc/1.0.7/download",
        type = "tar.gz",
        sha256 = "adab1eaa3408fb7f0c777a73e7465fd5656136fc93b670eb6df3c88c2c1344e3",
        strip_prefix = "indoc-1.0.7",
        build_file = Label("//cargo/remote:BUILD.indoc-1.0.7.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__libc__0_2_132",
        url = "https://crates.io/api/v1/crates/libc/0.2.132/download",
        type = "tar.gz",
        sha256 = "8371e4e5341c3a96db127eb2465ac681ced4c433e01dd0e938adbef26ba93ba5",
        strip_prefix = "libc-0.2.132",
        build_file = Label("//cargo/remote:BUILD.libc-0.2.132.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__lock_api__0_4_8",
        url = "https://crates.io/api/v1/crates/lock_api/0.4.8/download",
        type = "tar.gz",
        sha256 = "9f80bf5aacaf25cbfc8210d1cfb718f2bf3b11c4c54e5afe36c236853a8ec390",
        strip_prefix = "lock_api-0.4.8",
        build_file = Label("//cargo/remote:BUILD.lock_api-0.4.8.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__memoffset__0_6_5",
        url = "https://crates.io/api/v1/crates/memoffset/0.6.5/download",
        type = "tar.gz",
        sha256 = "5aa361d4faea93603064a027415f07bd8e1d5c88c9fbf68bf56a285428fd79ce",
        strip_prefix = "memoffset-0.6.5",
        build_file = Label("//cargo/remote:BUILD.memoffset-0.6.5.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__once_cell__1_13_1",
        url = "https://crates.io/api/v1/crates/once_cell/1.13.1/download",
        type = "tar.gz",
        sha256 = "074864da206b4973b84eb91683020dbefd6a8c3f0f38e054d93954e891935e4e",
        strip_prefix = "once_cell-1.13.1",
        build_file = Label("//cargo/remote:BUILD.once_cell-1.13.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__parking_lot__0_12_1",
        url = "https://crates.io/api/v1/crates/parking_lot/0.12.1/download",
        type = "tar.gz",
        sha256 = "3742b2c103b9f06bc9fff0a37ff4912935851bee6d36f3c02bcc755bcfec228f",
        strip_prefix = "parking_lot-0.12.1",
        build_file = Label("//cargo/remote:BUILD.parking_lot-0.12.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__parking_lot_core__0_9_3",
        url = "https://crates.io/api/v1/crates/parking_lot_core/0.9.3/download",
        type = "tar.gz",
        sha256 = "09a279cbf25cb0757810394fbc1e359949b59e348145c643a939a525692e6929",
        strip_prefix = "parking_lot_core-0.9.3",
        build_file = Label("//cargo/remote:BUILD.parking_lot_core-0.9.3.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__proc_macro2__1_0_43",
        url = "https://crates.io/api/v1/crates/proc-macro2/1.0.43/download",
        type = "tar.gz",
        sha256 = "0a2ca2c61bc9f3d74d2886294ab7b9853abd9c1ad903a3ac7815c58989bb7bab",
        strip_prefix = "proc-macro2-1.0.43",
        build_file = Label("//cargo/remote:BUILD.proc-macro2-1.0.43.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__pyo3__0_17_1",
        url = "https://crates.io/api/v1/crates/pyo3/0.17.1/download",
        type = "tar.gz",
        sha256 = "12f72538a0230791398a0986a6518ebd88abc3fded89007b506ed072acc831e1",
        strip_prefix = "pyo3-0.17.1",
        build_file = Label("//cargo/remote:BUILD.pyo3-0.17.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__pyo3_build_config__0_17_1",
        url = "https://crates.io/api/v1/crates/pyo3-build-config/0.17.1/download",
        type = "tar.gz",
        sha256 = "fc4cf18c20f4f09995f3554e6bcf9b09bd5e4d6b67c562fdfaafa644526ba479",
        strip_prefix = "pyo3-build-config-0.17.1",
        build_file = Label("//cargo/remote:BUILD.pyo3-build-config-0.17.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__pyo3_ffi__0_17_1",
        url = "https://crates.io/api/v1/crates/pyo3-ffi/0.17.1/download",
        type = "tar.gz",
        sha256 = "a41877f28d8ebd600b6aa21a17b40c3b0fc4dfe73a27b6e81ab3d895e401b0e9",
        strip_prefix = "pyo3-ffi-0.17.1",
        build_file = Label("//cargo/remote:BUILD.pyo3-ffi-0.17.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__pyo3_macros__0_17_1",
        url = "https://crates.io/api/v1/crates/pyo3-macros/0.17.1/download",
        type = "tar.gz",
        sha256 = "2e81c8d4bcc2f216dc1b665412df35e46d12ee8d3d046b381aad05f1fcf30547",
        strip_prefix = "pyo3-macros-0.17.1",
        build_file = Label("//cargo/remote:BUILD.pyo3-macros-0.17.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__pyo3_macros_backend__0_17_1",
        url = "https://crates.io/api/v1/crates/pyo3-macros-backend/0.17.1/download",
        type = "tar.gz",
        sha256 = "85752a767ee19399a78272cc2ab625cd7d373b2e112b4b13db28de71fa892784",
        strip_prefix = "pyo3-macros-backend-0.17.1",
        build_file = Label("//cargo/remote:BUILD.pyo3-macros-backend-0.17.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__quote__1_0_21",
        url = "https://crates.io/api/v1/crates/quote/1.0.21/download",
        type = "tar.gz",
        sha256 = "bbe448f377a7d6961e30f5955f9b8d106c3f5e449d493ee1b125c1d43c2b5179",
        strip_prefix = "quote-1.0.21",
        build_file = Label("//cargo/remote:BUILD.quote-1.0.21.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__redox_syscall__0_2_16",
        url = "https://crates.io/api/v1/crates/redox_syscall/0.2.16/download",
        type = "tar.gz",
        sha256 = "fb5a58c1855b4b6819d59012155603f0b22ad30cad752600aadfcb695265519a",
        strip_prefix = "redox_syscall-0.2.16",
        build_file = Label("//cargo/remote:BUILD.redox_syscall-0.2.16.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__scopeguard__1_1_0",
        url = "https://crates.io/api/v1/crates/scopeguard/1.1.0/download",
        type = "tar.gz",
        sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd",
        strip_prefix = "scopeguard-1.1.0",
        build_file = Label("//cargo/remote:BUILD.scopeguard-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__smallvec__1_9_0",
        url = "https://crates.io/api/v1/crates/smallvec/1.9.0/download",
        type = "tar.gz",
        sha256 = "2fd0db749597d91ff862fd1d55ea87f7855a744a8425a64695b6fca237d1dad1",
        strip_prefix = "smallvec-1.9.0",
        build_file = Label("//cargo/remote:BUILD.smallvec-1.9.0.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__syn__1_0_99",
        url = "https://crates.io/api/v1/crates/syn/1.0.99/download",
        type = "tar.gz",
        sha256 = "58dbef6ec655055e20b86b15a8cc6d439cca19b667537ac6a1369572d151ab13",
        strip_prefix = "syn-1.0.99",
        build_file = Label("//cargo/remote:BUILD.syn-1.0.99.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__target_lexicon__0_12_4",
        url = "https://crates.io/api/v1/crates/target-lexicon/0.12.4/download",
        type = "tar.gz",
        sha256 = "c02424087780c9b71cc96799eaeddff35af2bc513278cda5c99fc1f5d026d3c1",
        strip_prefix = "target-lexicon-0.12.4",
        build_file = Label("//cargo/remote:BUILD.target-lexicon-0.12.4.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__unicode_ident__1_0_3",
        url = "https://crates.io/api/v1/crates/unicode-ident/1.0.3/download",
        type = "tar.gz",
        sha256 = "c4f5b37a154999a8f3f98cc23a628d850e154479cd94decf3414696e12e31aaf",
        strip_prefix = "unicode-ident-1.0.3",
        build_file = Label("//cargo/remote:BUILD.unicode-ident-1.0.3.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__unindent__0_1_10",
        url = "https://crates.io/api/v1/crates/unindent/0.1.10/download",
        type = "tar.gz",
        sha256 = "58ee9362deb4a96cef4d437d1ad49cffc9b9e92d202b6995674e928ce684f112",
        strip_prefix = "unindent-0.1.10",
        build_file = Label("//cargo/remote:BUILD.unindent-0.1.10.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_sys__0_36_1",
        url = "https://crates.io/api/v1/crates/windows-sys/0.36.1/download",
        type = "tar.gz",
        sha256 = "ea04155a16a59f9eab786fe12a4a450e75cdb175f9e0d80da1e17db09f55b8d2",
        strip_prefix = "windows-sys-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows-sys-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_aarch64_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_aarch64_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "9bb8c3fd39ade2d67e9874ac4f3db21f0d710bee00fe7cab16949ec184eeaa47",
        strip_prefix = "windows_aarch64_msvc-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows_aarch64_msvc-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_i686_gnu__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_i686_gnu/0.36.1/download",
        type = "tar.gz",
        sha256 = "180e6ccf01daf4c426b846dfc66db1fc518f074baa793aa7d9b9aaeffad6a3b6",
        strip_prefix = "windows_i686_gnu-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows_i686_gnu-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_i686_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_i686_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "e2e7917148b2812d1eeafaeb22a97e4813dfa60a3f8f78ebe204bcc88f12f024",
        strip_prefix = "windows_i686_msvc-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows_i686_msvc-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_x86_64_gnu__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_x86_64_gnu/0.36.1/download",
        type = "tar.gz",
        sha256 = "4dcd171b8776c41b97521e5da127a2d86ad280114807d0b2ab1e462bc764d9e1",
        strip_prefix = "windows_x86_64_gnu-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows_x86_64_gnu-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "cargo__windows_x86_64_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_x86_64_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "c811ca4a8c853ef420abd8592ba53ddbbac90410fab6903b3e79972a631f7680",
        strip_prefix = "windows_x86_64_msvc-0.36.1",
        build_file = Label("//cargo/remote:BUILD.windows_x86_64_msvc-0.36.1.bazel"),
    )
