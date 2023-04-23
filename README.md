<div align="center">

# asdf-unison [![Build](https://github.com/susurri/asdf-unison/actions/workflows/build.yml/badge.svg)](https://github.com/susurri/asdf-unison/actions/workflows/build.yml) [![Lint](https://github.com/susurri/asdf-unison/actions/workflows/lint.yml/badge.svg)](https://github.com/susurri/asdf-unison/actions/workflows/lint.yml)


[unison](https://www.unison-lang.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add unison
# or
asdf plugin add unison https://github.com/susurri/asdf-unison.git
```

unison:

```shell
# Show all installable versions
asdf list-all unison

# Install specific version
asdf install unison latest

# Set a version globally (on your ~/.tool-versions file)
asdf global unison latest

# Now unison commands are available
ucm --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/susurri/asdf-unison/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [susurri](https://github.com/susurri/)
