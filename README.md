# aspm - Atom-Shell package manager
[![build status](http://img.shields.io/travis/bwin/master/aspm.svg?style=flat-square)](https://travis-ci.org/bwin/aspm)
[![dependencies](http://img.shields.io/david/bwin/aspm.svg?style=flat-square)](https://david-dm.org/bwin/aspm)
[![npm version](http://img.shields.io/npm/v/aspm.svg?style=flat-square)](https://npmjs.org/package/aspm)

> A node CLI script like npm but for Atom-Shell. Install and build npm-modules for Atom-Shell.

`aspm` is designed as a replacement for `npm` if you're working on an Atom-Shell project.

**Warning:** *May be unreliable at the moment.*

**Table of Contents**
- [Prequisities](#prequisities)
- [Installation](#installation)
- [Quick-Start](#quick-start)
- [Usage](#usage)
- [Configuration (optional)](#configuration-optional)
  - [Overriding configuration](#overriding-configuration)
  - [Without configuration](#without-configuration)
- [Examples](#examples)
- [How it works](#how-it-works)
  - [Under the hood](#under-the-hood)
  - [Support for modules that use `node-pre-gyp`](#support-for-modules-that-use-node-pre-gyp)
- [BTW](#btw)

## Prequisities
Since you're using Atom-Shell you most likely have those installed already.
- `node` & `npm`(global)
- `node-gyp`(global), also fulfill it's [requirements](https://github.com/TooTallNate/node-gyp#installation).

## Installation
Install (preferred globally) with `npm install aspm -g`.

## Quick-Start
- Install globally with npm. `npm install -g aspm`
- Add some configuration to your package.json. (See Configuration. This is optional but highly recommended.)
- Now use `aspm` in place of `npm` in your project.

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
    -p, --target-platform <platform>  target platform
    -s, --save                        save as dependency to package.json
    -s, --save-dev                    save as devDependency to package.json
    -g                                install globally with normal npm
    --tarball [url/path]              install from [remote] tarball
    --quiet                           don't say anything
```

## Configuration (optional)
You can (and should to make things more convenient) configure default values for target, arch and platform in your `package.json`.
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
This way you can use it just like npm without additional parameters (for basic tasks as shown in usage).

### Overriding configuration
You can always set/override some or all configuration values. For example: `aspm install --target 0.19.5 --arch ia32`.

### Without configuration
**Important:** If you don't specify default values, you'll always have to provide at least a target and arch.

## Examples
Please note that `sqlite3` as an example does not work at the moment because of `node-pre-gyp`.
```
# Install all modules from package.json
aspm install

# Install specific module and save as dependency in package.json
aspm install sqlite3 --save

# Install specific module in a specific version and save as dependency in package.json
aspm install sqlite3@3.0.4 --save

# Install multiple module and save as dependency in package.json
aspm install sqlite3 async --save

# Install module from tarball
# In contrast to npm you have to specify the module name here too.
aspm install sqlite3 --tarball https://github.com/mapbox/node-sqlite3/archive/master.tar.gz --target 0.19.5 --arch ia32

# Build a specific module for a specific target
aspm build sqlite3 --target 0.19.5 --arch ia32

# fetch all modules from package.json, then build all in a separate step
aspm fetch
aspm build
```

## How it works

### Under the hood
To fetch the modules we just call out to `npm` with `--ignore-scripts`. To build and `node-gyp` with some additional arguments.

### Support for modules that use `node-pre-gyp`
We have basic support for compiling modules that use `node-pre-gyp` (i.e. `sqlite3`) by faking some stuff.

## BTW
There may or may not be several (maybe better?) alternatives to this.
- https://github.com/atom/atom-shell/blob/master/docs/tutorial/using-native-node-modules.md

I haven't looked into these, yet.
- https://github.com/paulcbetts/grunt-build-atom-shell
- https://github.com/atom/atom-shell-starter in scripts/
- https://github.com/probablycorey/atom-node-module-installer