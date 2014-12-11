# TODO

## sooner
- [ ] add examples directory
- [x] fake support for current node-pre-gyp with lookup table as-ver -> node_abi (check n-pre-g ver from package)
- [x] node-gyp configure
- [x] readme: switch examples to "with config" by default and explain how to set/override trough CLI
- [x] fix building for a specific module ver `sqlite@3.0.4`
- [x] output for cmd is "> #{cmd}"
- [x] test `aspm i package1 package2 package3`
- [x] readme: add example "aspm i package1 package2@1.0.0 package3"
- [ ] add `aspm update`
- [ ] test new node-pre-gyp versioning patch
- [x] add tests, travis
- [x] test specific vers of printer, sqlite3
- [x] fix tests
- [x] readme: explain under the hood (npm, node-gyp)
- [ ] readme: better explain under the hood
- [x] readme: quick start
- [ ] readme: better explain node-pre-gyp support (you get the "node" and the "gyp", without the "pre")
- [x] readme: mention atom-shell-starter and that you will look into this and the other one mentioned in BTW
- [x] check if cmd ends in `gyp ok`
- [x] separate cli and api
- [x] pass-trough other actions to npm (dedupe, shrinkwrap, outdated, version, search, publish, ...)
- [ ] allow overriding of `--dist-url` (also from config)
- [ ] error handling/reporting
- [ ] --verbose
- [x] --quiet
- [x] cli colors (https://github.com/tinganho/terminal-colors)
- [ ] gist with atom-shell-require-sqlite3-test
- [ ] PR node-pre-gyp: patch versioning.js and republish to npm
- [ ] PR node-sqlite3: update node-pre-gyp and republish to npm
- [ ] start discussion (with examples) with mapbox (dane, mithgol) for patching node-pre-gyp
- [ ] look at grunt-build-atom-shell (maybe PR fake-node-pre-gyp?)
- [ ] add ~/.aspm/config.json
- [ ] 

## later
- [x] precompile coffee ~~[`npm prepublish`?]~~, move `coffee-script` to devDependency
- [ ] test cross-compilation with `--target-platform`
- [ ] ask someone else to test on darwin (lago1283?)
- [ ] `--no-colors`
- [ ] build modules recursive
- [ ] 
 
# MAYBE's
- [ ] only do `node-gyp configure` on rebuild?
- [ ] new branch: use `minimist`
- [ ] node-pre-gyp: or fallback to `lib/binding/`?
- [ ] add `aspm init`?
- [ ] add `aspm config`?
- [ ] copy `node-pre-gyp` tests?
- [ ] 
