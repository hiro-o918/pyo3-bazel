load("@bazel_skylib//lib:paths.bzl", "paths")

def _symlink_python_lib(ctx):
    target_name = ctx.attr.pkg_name + ".so"
    src_file = ctx.files.src[0]
    out = ctx.actions.declare_file(target_name)
    ctx.actions.symlink(output = out, target_file = src_file)

    return [DefaultInfo(files = depset([out]))]

symlink_python_lib = rule(
    implementation = _symlink_python_lib,
    attrs = {
        "src": attr.label(),
        'pkg_name': attr.string(),
    },
)
