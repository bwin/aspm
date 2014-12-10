
# aspm - Atom-Shell package manager

[![dependencies](http://img.shields.io/david/bwin/aspm.svg?style=flat-square)](https://david-dm.org/bwin/aspm)
[![npm version](http://img.shields.io/npm/v/aspm.svg?style=flat-square)](https://npmjs.org/package/aspm)

> Install and build modules for Atom-Shell.

**Warning:** *Very early alpha*

## Prequisities
You need a globally installed `node-gyp` and also fulfill it's [requirements](https://github.com/TooTallNate/node-gyp#installation).

## Installation

Install (preferred globally) with `npm install aspm -g`

## Usage

```
  Usage: aspm [options] [command]

  Commands:

    install|i [module]  install module (fetch & build)
    fetch|f [module]    fetch module
    build|b <module>    build module

  Options:

    -h, --help                        output usage information
    -V, --version                     output the version number
    -t, --target <version>            Atom-Shell version
    -a, --arch <arch>                 target architecture
    -a, --target-platform <platform>  target platform
    -s, --save                        save as dependency to package.json
    -s, --save-dev                    save as devDependency to package.json
    --tarball                         (fetch the url and) install from tarball.
```

## Examples

### Install all modules from package.json
`aspm install --target 0.19.5 --arch ia32`

### Install specific module and save as dependency in package.json
`aspm install sqlite3 --save --target 0.19.5 --arch ia32`

### Install module from tarball
`aspm install sqlite3 --tarball https://github.com/mapbox/node-sqlite3/archive/master.tar.gz --target 0.19.5 --arch ia32`

### Install specific module and save as dependency in package.json
`aspm install sqlite3 --tarball https://github.com/mapbox/node-sqlite3/archive/master.tar.gz --target 0.19.5 --arch ia32`

### Build a specific module
`aspm build sqlite3 --target 0.19.5 --arch ia32`

## Configuration (optional)
You can configure default values for target, arch and platform in your package.json
```js
{
	"config": {
		"atom-shell": {
			"version": "0.19.5",
			"arch": "ia32",
			"platform": "win32"
		}
	}
}
```

## BTW
I discovered that somebody else has done something similar at https://github.com/probablycorey/atom-node-module-installer