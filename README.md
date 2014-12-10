
# aspm - Atom-Shell package manager

[![dependencies](http://img.shields.io/david/bwin/aspm.svg?style=flat-square)](https://david-dm.org/bwin/aspm)
[![npm version](http://img.shields.io/npm/v/aspm.svg?style=flat-square)](https://npmjs.org/package/aspm)

> A node CLI script like npm but for Atom-Shell. Install and build npm-modules for Atom-Shell.

**Warning:** *May be unreliable at the moment.*

## Prequisities
Since you're using Atom-Shell you most likely have those installed already.
- `node` & `npm`(global)
- `node-gyp`(global), also fulfill it's [requirements](https://github.com/TooTallNate/node-gyp#installation).

## Installation
Install (preferred globally) with `npm install aspm -g`.

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

# Install module from tarball
# In contrast to npm you have to specify the module name here too.
aspm install sqlite3 --tarball https://github.com/mapbox/node-sqlite3/archive/master.tar.gz --target 0.19.5 --arch ia32

# Build a specific module for a specific target
aspm build sqlite3 --target 0.19.5 --arch ia32
```

## BTW
There may or may not be several (maybe better?) alternatives to this.
- https://github.com/atom/atom-shell/blob/master/docs/tutorial/using-native-node-modules.md

I haven't looked into these, yet.
- https://github.com/paulcbetts/grunt-build-atom-shell
- https://github.com/atom/atom-shell-starter in scripts/
- https://github.com/probablycorey/atom-node-module-installer