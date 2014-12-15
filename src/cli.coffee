
exec = require('child_process').exec

program = require 'commander'

aspm = require '../lib'

pkg = require '../package.json'

fail = (err) ->
	console.error err.message
	console.error "not ok".red
	process.exit 1
	return

program
.version "v#{pkg.version}"
.description 'Install and build npm modules for Atom-Shell'
.option '-t, --target <version>', 'Atom-Shell version'
.option '-a, --arch <arch>', 'target architecture'
.option '-p, --target-platform <platform>', 'target platform'
.option '-s, --save', 'save as dependency to package.json'
.option '-s, --save-dev', 'save as devDependency to package.json'
.option '-g', 'install globally with normal npm'
.option '--tarball [url/path]', 'install from [remote] tarball'
.option '--quiet', "don't say anything"
.option '--run-scripts', "do not use --ignore-scripts flag"
.option '--compatibility', "try for max compability"

program
.command 'install [module]'
.alias 'i'
.description 'install module (fetch & build)'
.action (module) ->
	if program.G
		# with -g flag we use npm directly
		cmd = "npm #{process.argv.slice(2).join(' ')}"
		aspm.runCmd cmd, {}, no, (err) -> fail err if err; console.log "ok".green
	else
		aspm.installModule module, program, (err) -> fail err if err; console.log "ok".green

program
.command 'fetch [module]'
.alias 'f'
.description 'fetch module'
.action (module) ->
	aspm.fetchModule module, program, (err) -> fail err if err; console.log "ok".green

program
.command 'build <module>'
.alias 'b'
.description 'build module'
.action (module) ->
	aspm.buildModule module, program, (err) -> fail err if err; console.log "ok".green


# pass-through some npm commands directly
# we only do build, install, rebuild, update
if process.argv[2] in 'adduser bin bugs bundle cache completion config dedupe deprecate docs edit explore help help-search init info link ls npm outdated owner pack prefix prune publish repo restart rm root run run-script search shrinkwrap star stars start stop tag test uninstall unpublish version view whoami'.split ' '
	cmd = "npm #{process.argv.slice(2).join(' ')}"
	aspm.runCmd cmd, {}, no, (err) -> fail err if err; console.log "ok".green
else
	program.parse process.argv
	program.help() if program.args.length is 0


