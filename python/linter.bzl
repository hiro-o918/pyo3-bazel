load("@rules_python//python:defs.bzl", "py_binary", "py_test")
load("@pip//:requirements.bzl", "requirement")

def black_lint(name, srcs, deps = [], data = [], args = [], **kwargs):
    py_test(
        name = name,
        srcs = [
            "//python/tools:run_black.py",
        ] + srcs,
        main = "//python/tools:run_black.py",
        args = [
                   "--config",
                   "$(location //python:pyproject.toml)",
                   "--check",
                   "--diff",
               ] +
               ["$(execpath :%s)" % x for x in srcs] +
               args,
        deps = deps + [
            requirement("black"),
        ],
        data = [
            "//python:pyproject.toml",
        ] + data,
        **kwargs
    )

def black_format(name, srcs, deps = [], data = [], args = [], **kwargs):
    py_binary(
        name = name,
        srcs = [
            "//python/tools:run_black.py",
        ] + srcs,
        main = "//python/tools:run_black.py",
        args = [
                   "--config",
                   "$(location //python:pyproject.toml)",
               ] +
               ["$(execpath :%s)" % x for x in srcs] +
               args,
        deps = deps + [
            requirement("black"),
        ],
        data = [
            "//python:pyproject.toml",
        ] + data,
        **kwargs
    )

def isort_lint(name, srcs, deps = [], data = [], args = [], **kwargs):
    py_test(
        name = name,
        srcs = [
            "//python/tools:run_isort.py",
        ] + srcs,
        main = "//python/tools:run_isort.py",
        args = [
                   "--sp",
                   "$(location //python:pyproject.toml)",
                   "--check",
                   "--diff",
               ] +
               ["$(execpath :%s)" % x for x in srcs] +
               args,
        deps = deps + [
            requirement("isort"),
        ],
        data = [
            "//python:pyproject.toml",
        ] + data,
        **kwargs
    )

def isort_format(name, srcs, deps = [], data = [], args = [], **kwargs):
    py_binary(
        name = name,
        srcs = [
            "//python/tools:run_isort.py",
        ] + srcs,
        main = "//python/tools:run_isort.py",
        args = [
                   "--sp",
                   "$(location //python:pyproject.toml)",
               ] +
               ["$(execpath :%s)" % x for x in srcs] +
               args,
        deps = deps + [
            requirement("isort"),
        ],
        data = [
            "//python:pyproject.toml",
        ] + data,
        **kwargs
    )
