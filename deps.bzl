load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def go_dependencies():
    go_repository(
        name = "com_github_coreos_go_systemd_v22",
        importpath = "github.com/coreos/go-systemd/v22",
        sum = "h1:rtAn27wIbmOGUs7RIbVgPEjb31ehTVniDwPGXyMxm5U=",
        version = "v22.3.3-0.20220203105225-a9a7ef127534",
    )
    go_repository(
        name = "com_github_godbus_dbus_v5",
        importpath = "github.com/godbus/dbus/v5",
        sum = "h1:9349emZab16e7zQvpmsbtjc18ykshndd8y2PG3sgJbA=",
        version = "v5.0.4",
    )

    go_repository(
        name = "com_github_mattn_go_colorable",
        importpath = "github.com/mattn/go-colorable",
        sum = "h1:fFA4WZxdEF4tXPZVKMLwD8oUnCTTo08duU7wxecdEvA=",
        version = "v0.1.13",
    )
    go_repository(
        name = "com_github_mattn_go_isatty",
        importpath = "github.com/mattn/go-isatty",
        sum = "h1:bq3VjFmv/sOjHtdEhmkEV4x1AJtvUvOJ2PFAZ5+peKQ=",
        version = "v0.0.16",
    )
    go_repository(
        name = "com_github_pkg_errors",
        importpath = "github.com/pkg/errors",
        sum = "h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=",
        version = "v0.9.1",
    )
    go_repository(
        name = "com_github_rs_xid",
        importpath = "github.com/rs/xid",
        sum = "h1:qd7wPTDkN6KQx2VmMBLrpHkiyQwgFXRnkOLacUiaSNY=",
        version = "v1.4.0",
    )

    go_repository(
        name = "com_github_rs_zerolog",
        importpath = "github.com/rs/zerolog",
        sum = "h1:MirSo27VyNi7RJYP3078AA1+Cyzd2GB66qy3aUHvsWY=",
        version = "v1.28.0",
    )
    go_repository(
        name = "org_golang_x_sys",
        importpath = "golang.org/x/sys",
        sum = "h1:v6hYoSR9T5oet+pMXwUWkbiVqx/63mlHjefrHmxwfeY=",
        version = "v0.0.0-20220829200755-d48e67d00261",
    )

def cargo_sys_dependencies():
    # maybe(
    #     git_repository,
    #     name = "lib_lightgbm",
    #     commit = "3cf764e438347d1aa12a1f1c464a6295cf7a6134",
    #     remote = "https://github.com/vaaaaanquish/LightGBM.git",
    #     init_submodules = True,
    #     build_file = Label("//3rdparty/cargo:BUILD.lib_lightbgm.bazel"),
    #     # The version here should match the version used with the Rust crate `lightgbm-sys`
    #     shallow_since = "1610252734 +0900",
    # )

    maybe(
        git_repository,
        name = "lib_lightgbm",
        commit = "fdac51534170d6ff23d2628827d0d620128f4c1f",
        remote = "https://github.com/vaaaaanquish/lightgbm-rs.git",
        init_submodules = True,
        recursive_init_submodules = True,
        build_file = Label("//3rdparty/cargo:BUILD.lib_lightbgm.bazel"),
        # # The version here should match the version used with the Rust crate `lightgbm-sys`
        # shallow_since = "1610252734 +0900",
    )
