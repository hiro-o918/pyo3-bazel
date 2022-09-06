def _go_archive_header(ctx):
    cc_header = ctx.attr.cc_lib[CcInfo].compilation_context.headers.to_list()[0]
    return DefaultInfo(
        files = depset([cc_header]),
    )

go_archive_header = rule(
    implementation = _go_archive_header,
    attrs = {
        "cc_lib": attr.label(
            providers = [CcInfo],
        ),
    },
)
