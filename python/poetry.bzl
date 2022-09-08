def _requirements_lock_impl(ctx):
    result = ctx.execute(
        [
            "poetry",
            "export",
            "--dev",
        ],
        working_directory = str(ctx.path(ctx.attr.lockfile).dirname),
    )
    if result.return_code:
        fail("failed to build: {}".format(result.stderr))
    ctx.file(ctx.attr.requirements_lock, result.stdout)
    ctx.file("BUILD", "")

requirements_lock = repository_rule(
    implementation = _requirements_lock_impl,
    local = True,
    attrs = {
        "lockfile": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "requirements_lock": attr.string(
            default = "requirements_lock.txt",
        ),
    },
)
