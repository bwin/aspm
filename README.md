# aspm - Atom-Shell package manager
[![build status](http://img.shields.io/travis/bwin/aspm/master.svg?style=flat-square)](https://travis-ci.org/bwin/aspm)
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

## Motivation
There are several ways to build modules for atom-shell, but none of them felt quite right for my needs. Also, since `node-pre-gyp` doesn't yet support atom-shell, it gets even worse for modules using that.
This tries to be as convenient as possible for a small project. Just use it for everything in your project as you would use `npm`. Most of the time it does just pass-through to `npm` anyway.
If you're compiling for several platforms/atom-shell-versions on the same machine, it probably makes more sense to use Grunt build tasks (see [grunt-build-atom-shell](https://github.com/paulcbetts/grunt-build-atom-shell). This also allows renaming the executable file on Windows. Probably even more.).

Maybe this is unnecessary, does it the wrong way, is generally a stupid idea or whatever. (But at the time it works for me and makes updating atom-shell easier for me. Atom-shell-starter and grunt-build-atom-shell came after I started my current project.)

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

Most npm commands are just passed trough to npm (dedupe, shrinkwrap, etc. should all work normally).

Unlike npm which takes its parameters in the form `--target=1.2.3`, aspm expects `--target 1.2.3`.

Also if you try to install globally with `-g` we bail out and just pretend you used npm in the first place, since it wouldn't make much sense to install for atom-shell globally.
To do that anyways, you can use the `--g-yes-install-for-atom-shell-globally` flag. (No, you can't.)

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
```
# Install all modules from package.json
aspm install

# Install specific module and save as dependency in package.json
aspm install serialport --save

# Install specific module in a specific version and save as dependency in package.json
aspm install sqlite3@3.0.4 --save

# Install multiple module and save as dependency in package.json
aspm install pathwatcher v8-profiler --save

# Install module from tarball
# In contrast to npm you have to specify the module name here too.
aspm install sqlite3 --tarball https://github.com/mapbox/node-sqlite3/archive/master.tar.gz --target 0.19.5 --arch ia32

# Build a specific module for a specific target
aspm build leveldown --target 0.19.5 --arch ia32
# or shorter
aspm b leveldown -t 0.19.5 -a ia32

# fetch all modules from package.json, then build all in a separate step
aspm fetch
aspm build
```

## How it works

### Under the hood
To fetch the modules we just call out to `npm` with `--ignore-scripts`. To build we use `node-gyp` with some additional arguments.

### Support for modules that use `node-pre-gyp`
We have basic support for compiling modules that use `node-pre-gyp` (i.e. `sqlite3`) by faking some stuff.

## Hints
- [sqlite3]() in version 3.0.4 (current npm) won't compile for atom-shell >= 0.18.0. We can't change that. But it's possible to build with the current github master. (And it will when 3.0.5 or whatever comes next is released.)
- The [test suite](https://travis-ci.org/bwin/aspm) compiles and requires a few modules for a few atom-shell versions on ia32 and x64.
  - Modules/Packages: `time@0.11.0`, `leveldown@1.0.0`, `nslog@1.0.1`, `pathwatcher@2.3.5`, `serialport@1.4.9`, `zipfile@0.5.4`, `v8-profiler@5.2.1`, `sqlite3@3.0.4` & `sqlite3@master`(see above)
  - Atom-Shell versions: 0.17.2, 0.19.5, current
  - Platforms: linux ia32 & x64 on travis-ci and locally tested in a vm on Windows 7

- I don't really know about Mac compability, since I don't have one here at the moment.
- Modules with native dependencies won't get compiled at the moment. Well, their dependencies won't be. This makes using something like `nano` (which depends on `serialport`) impossible at the moment.

## BTW
There may or may not be several (maybe better?) alternatives to this.
- https://github.com/atom/atom-shell/blob/master/docs/tutorial/using-native-node-modules.md

I haven't looked into these, yet.
- https://github.com/paulcbetts/grunt-build-atom-shell
- https://github.com/atom/atom-shell-starter in scripts/
- https://github.com/probablycorey/atom-node-module-installer