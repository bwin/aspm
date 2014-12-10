
program = require 'commander'

aspm = require '../lib'

try
	pkg = require '../package.json'
catch e

fail = ->
	console.error "\nnot ok".red
	process.exit 1
	return

program
.version "v#{pkg.version}"
.description 'Install and build npm modules for Atom-Shell'
.option '-t, --target <version>', 'Atom-Shell version'
.option '-a, --arch <arch>', 'target architecture'
.option '-a, --target-platform <platform>', 'target platform'
.option '-s, --save', 'save as dependency to package.json'
.option '-s, --save-dev', 'save as devDependency to package.json'
.option '--tarball', '(fetch the url and) install from tarball.'
.option '--no-production', 'disable passing "--production" flag to npm.'
.option '--quiet', 'pshht.'

program
.command 'install [module]'
.alias 'i'
.description 'install module (fetch & build)'
.action (module) ->
	aspm.installModule module, program, (err) -> fail err if err; console.log "ok".green

program
.command 'fetch [module]'
.alias 'f'
.description 'fetch module'
.action (module) ->
	aspm.fetchModule module, program, -> (err) -> fail err if err; console.log "ok".green

program
.command 'build <module>'
.alias 'b'
.description 'build module'
.action (module) ->
	aspm.buildModule module, program, -> (err) -> fail err if err; console.log "ok".green


program.parse process.argv
program.help() if program.args.length is 0