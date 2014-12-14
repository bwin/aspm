# TODO

## sooner
- [ ] tests: "modules /w yyy": "moduleName": "moduleVersion"(?): "for atom-shell...": "build"/"require"
- [ ] pass trough whole argv to npm install plus(maybe) --ignore-scripts
- [ ] build modules recursively !!
- [ ] meta[test]: install and build in test/
- [ ] test using `--build-from-source` for better compability
- [ ] investigate npm-only build way
- [ ] fix building `node-sass`
- [ ] fix building `nodegit`
- [ ] have a `npm run clean`-script to `rm -rf test/node_modules/`
- [ ] add commands: rebuild, update
- [ ] add examples directory
- [ ] readme: better explain under the hood
- [ ] readme: better explain node-pre-gyp support (you get the "node" and the "gyp", without the "pre")
- [ ] allow overriding of `--dist-url` (also from config)
- [ ] error handling/reporting
- [ ] gist with atom-shell-require-sqlite3-test
- [ ] add ~/.aspm/config.json
- [ ] 

## later
- [ ] test cross-compilation with `--target-platform`
- [ ] ask someone else to test on darwin (lago1283?)
- [ ] PR node-pre-gyp: patch versioning.js and republish to npm
- [ ] PR node-sqlite3: update node-pre-gyp and republish to npm
- [ ] start discussion (with examples) with mapbox (dane, mithgol) for patching node-pre-gyp
- [ ] look at grunt-build-atom-shell (maybe PR fake-node-pre-gyp?)
- [ ] `--no-colors`
- [x] --verbose
- [ ] 
 
# MAYBE's
- [ ] install modules somewhere else
- [ ] simplify installModule?
- [ ] new branch: use `minimist`
- [ ] add `aspm init`?
- [ ] add `aspm config`?
- [ ] copy `node-pre-gyp` tests?
- [ ] 
