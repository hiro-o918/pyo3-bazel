def _extract_cc_header(ctx):
    headers = ctx.attr.cc_lib[CcInfo].compilation_context.headers.to_list()
    print([h.path for h in headers])
    extract_header = [
        header
        for header in headers
        if header.path.endswith(ctx.attr.header_name)
    ]
    if len(extract_header) == 0:
        fail("no such header: {}".format(ctx.attr.header_name))
    print(extract_header[0].path)
    return DefaultInfo(
        files = depset([extract_header[0]]),
    )

def _extract_cc_binary(ctx):
    # TODO: extract binary by path
    binary = ctx.attr.cc_lib[CcInfo].linking_context.linker_inputs.to_list()[0]
    return DefaultInfo(
        files = depset([binary.libraries[0].static_library]),
    )

extract_cc_header = rule(
    implementation = _extract_cc_header,
    attrs = {
        "cc_lib": attr.label(
            providers = [CcInfo],
        ),
        "header_name": attr.string(),
    },
)

extract_cc_binary = rule(
    implementation = _extract_cc_binary,
    attrs = {
        "cc_lib": attr.label(
            providers = [CcInfo],
        ),
        "binary_name": attr.string(),
    },
)
