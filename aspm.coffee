
fs = require 'fs'
path = require 'path'
os = require 'os'
exec = require('child_process').exec

program = require 'commander'
queue = require 'queue-async'

pkg = require './package.json'


# modified from https://gist.github.com/liangzan/807712#comment-337828
rmDirRecursiveSync = (dirPath) ->
	try
		files = fs.readdirSync(dirPath)
	catch e
		return
	if files.length > 0
		i = 0
		while i < files.length
			filePath = dirPath + "/" + files[i]
			if fs.statSync(filePath).isFile()
				fs.unlinkSync(filePath)
			else
				rmDirRecursiveSync filePath
			i++
	try fs.rmdirSync dirPath
	return

fetchModule = (module, cb) ->
	console.log "fetching #{module or 'all'}"
	module ?= ''
	module = program.tarball if program.tarball
	cmd = "npm install --ignore-scripts #{module}"
	cmd += ' --save' if program.save
	cmd += ' --save-dev' if program['save-dev']
	console.log cmd
	child = exec cmd
	child.stdout.pipe process.stdout
	child.stderr.pipe process.stderr
	child.on 'exit', -> cb?()
	return

buildModule = (module, cb) ->
	projectPkg = require path.join process.cwd(), 'package.json'
	config = projectPkg.config?['atom-shell']
	target = program.target or config?.version
	arch = program.arch or config?.arch
	platform = program['target-platform'] or config?['platform'] or os.platform()

	unless module
		# build all (serially)
		q = queue(1)
		for module of projectPkg.dependencies
			q.defer buildModule, module
			q.awaitAll (err) ->
				return cb()
		return

	unless target
		console.error 'aspm error: no atom-shell version specified.'
		process.exit 1
	unless arch
		console.error 'aspm error: no target architecture specified.'
		process.exit 1

	return cb() unless fs.existsSync path.join process.cwd(), 'node_modules', module, 'binding.gyp'
	
	console.log "building #{module or 'all'}"

	buildPkg = require path.join process.cwd(), 'node_modules', module, 'package.json'

	fakeNodePreGyp = buildPkg.dependencies?['node-pre-gyp']? and buildPkg.binary?
	if fakeNodePreGyp
		module_path = buildPkg.binary.module_path
		module_path = module_path.replace '{node_abi}', "atom-shell-v#{target}"
		module_path = module_path.replace '{platform}', os.platform()
		module_path = module_path.replace '{arch}', arch
		preGyp =
			module_name: buildPkg.binary.module_name
			module_path: path.join '..', module_path

	console.log "targeting Atom-Shell v#{target} #{os.platform()} #{arch}"
	cmd = "node-gyp rebuild --target=#{target} --arch=#{arch} --target_platform=#{platform} --dist-url=https://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist"
	if fakeNodePreGyp
		cmd += " --module_name=#{preGyp.module_name}"
		cmd += " --module_path=#{preGyp.module_path}"

	console.log cmd
	child = exec cmd,
		cwd: "node_modules/#{module}"
		#env:
		#	HOME: '~/.atom-shell-gyp'
	child.stdout.pipe process.stdout
	child.stderr.pipe process.stderr
	child.on 'exit', ->
		unless fakeNodePreGyp
			# we move the node_module.node file to lib/binding
			try fs.mkdirSync "node_modules/#{module}/lib/binding"
			fs.renameSync "node_modules/#{module}/build/Release/node_#{module}.node", "node_modules/#{module}/lib/binding/node_#{module}.node"
		rmDirRecursiveSync "node_modules/#{module}/build/"
		return cb?()
	return

installModule = (module, cb) ->
	console.log "installing #{module or 'all'}"
	fetchModule module, (err) ->
		buildModule module, (err) ->
			return cb?()
		return
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

program
.command 'install [module]'
.alias 'i'
.description 'install module (fetch & build)'
.action (module) ->
	installModule module

program
.command 'fetch [module]'
.alias 'f'
.description 'fetch module'
.action (module) ->
	fetchModule module

program
.command 'build <module>'
.alias 'b'
.description 'build module'
.action (module) ->
	buildModule module


program.parse process.argv
program.help() if program.args.length is 0
