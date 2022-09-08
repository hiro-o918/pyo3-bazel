# Python

Python environment with Bazel for the entire project.
This project depends on local Poetry and Python environment to manage packages.

## Setup development environment with poetry

```console
poetry config virtualenvs.create false --local
poetry install
```

You must create a virtualenv in this directory for the [settings.json](settings.json) to work.

## About Library of Project

In Bazel environment, first party libraries can be resolve, because they should be described in `deps`.
But it is not useful not to reference the libraries in development environment.

To solve this issue, PYTHONPATH is modified by the below ways

-   Add `packages` attribute by [pyproject.toml](pyproject.toml) for Python shell by poetry
-   Add `python.analysis.extraPaths` field to [settings.json](settings.json) for the interpreter of VSCode
