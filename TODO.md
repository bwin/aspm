# TODO

## sooner

- [x] readme: switch examples to "with config" by default and explain how to set/override trough CLI
- [ ] fix building for a specific module ver `sqlite@3.0.4`
- [x] output for cmd is "> #{cmd}"
- [ ] test `aspm i package1 package2 package3` & add example
- [ ] !!! fake support for current node-pre-gyp with lookup table as-ver -> node_abi
- [ ] add `aspm update`
- [ ] test new node-pre-gyp versioning patch
- [ ] add tests, travis
- [ ] readme: explain under the hood (npm, node-gyp)
- [ ] readme: mention node-pre-gyp support (you get the "node" and the "gyp", without the "pre")
- [ ] readme: mention atom-shell-starter and that you will look into this and the other one mentioned in BTW
- [ ] check if cmd ends in `gyp ok`
- [x] separate cli and api
- [ ] new branch: use `minimist`
- [ ] issue [discussion]: pass-trough other actions to npm (dedupe, shrinkwrap, outdated, version, search, publish, ...)
- [ ] allow overriding of `--dist-url` (also from config)
- [ ] `npm build`, `npm prepublish`, src/, lib/, .npmignore(src/???, appveyor.yml), move `coffee-script` to devDependency
- [ ] error handling
- [ ] --verbose
- [ ] --quiet
- [x] cli colors (https://github.com/tinganho/terminal-colors)
- [ ] gist with atom-shell-require-sqlite3-test
- [ ] PR node-pre-gyp: patch versioning.js and republish to npm
- [ ] PR node-sqlite3: update node-pre-gyp and republish to npm
- [ ] start discussion (with examples) with mapbox (dane, mithgol) for patching node-pre-gyp
- [ ] look at grunt-build-atom-shell (maybe PR fake-node-pre-gyp?)
- [ ] 

## later

- [ ] precompile coffee [`npm prepublish`?], move `coffee-script` to devDependency
- [ ] test cross-compilation with `--target-platform`
- [ ] ask someone else to test on darwin (lago1283?)
- [ ] `--no-colors`
- [ ] 
 
# MAYBE's

- [ ] issue [discussion]: use `--production` flag for npm by default? and add `--no-production` or `--dev`?
- [ ] use something else instead of `commander`? (`minimist`?)
- [ ] node-pre-gyp: or fallback to `lib/binding/`?
- [ ] add `aspm init`?
- [ ] add `aspm config`?
- [ ] copy `node-pre-gyp` tests?
- [ ] 


npmPasstrough = "dedupe shrinkwrap outdated version search publish"

(need/want semver?)
atomshellToModulesVersion =
	"0.16.x": 14
	"0.17.x": 15
	"0.18.x": 16
	"0.19.x": 16