
fs = require 'fs'
path = require 'path'
os = require 'os'
exec = require('child_process').exec

queue = require 'queue-async'
require 'terminal-colors'


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


configureModule = (module, program, cb) ->
	cmd = "node-gyp configure"
	console.log "> #{cmd}".lightBlue unless program.quiet
	child = exec cmd,
		cwd: "node_modules/#{module}"
	child.stdout.pipe process.stdout unless program.quiet
	child.stderr.pipe process.stderr
	child.on 'exit', (code) ->
		return cb?(new Error "node-gyp configure error") if code isnt 0
		cb?()
	return
	
module.exports.fetchModule = fetchModule = (module, program, cb) ->
	console.log "fetching #{module or 'all'}" unless program.quiet
	module ?= ''
	module = program.tarball if program.tarball
	cmd = "npm install --ignore-scripts #{module}"
	cmd += ' --save' if program.save
	cmd += ' --save-dev' if program['save-dev']
	#cmd += ' --production' unless program['no-production']
	console.log "> #{cmd}".lightBlue unless program.quiet
	child = exec cmd
	child.stdout.pipe process.stdout unless program.quiet
	child.stderr.pipe process.stderr
	child.on 'exit', (code) ->
		return cb?(new Error "npm install error") if code isnt 0
		#console.log "ok".green
		cb?()
	return

module.exports.buildModule = buildModule = (module, program, cb) ->
	projectPkg = require path.join process.cwd(), 'package.json'
	config = projectPkg.config?['atom-shell']
	target = program.target or config?.version
	arch = program.arch or config?.arch
	platform = program['target-platform'] or config?['platform'] or os.platform()
	modules = []

	# skip if module has no bynding.gyp
	return cb() unless fs.existsSync path.join process.cwd(), 'node_modules', module, 'binding.gyp'
	
	return cb?(new Error "aspm: no atom-shell version specified.") unless target
	return cb?(new Error "aspm: no target architecture specified.") unless arch

	modules = module.split ' ' if module.indexOf(' ') isnt -1
	modules = Object.keys projectPkg.dependencies unless module

	if modules.length isnt 0
		# build multiple modules serially and return
		q = queue(1)
		for module in modules
			q.defer buildModule, module
			q.awaitAll (err) ->
				return cb()
		return

	configureModule module, program, (err) ->
		console.log "building #{module} for Atom-Shell v#{target} #{os.platform()} #{arch}" unless program.quiet

		buildPkg = require path.join process.cwd(), 'node_modules', module, 'package.json'

		fakeNodePreGyp = buildPkg.dependencies?['node-pre-gyp']? and buildPkg.binary?
		if fakeNodePreGyp
			module_path = buildPkg.binary.module_path
			# fake node-pre-gyp
			module_path = module_path
			.replace '{node_abi}', "atom-shell-v#{target}"
			.replace '{platform}', os.platform()
			.replace '{arch}', arch
			
			preGyp =
				module_name: buildPkg.binary.module_name
				module_path: path.join '..', module_path

		cmd = "node-gyp rebuild --target=#{target} --arch=#{arch} --target_platform=#{platform} --dist-url=https://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist"
		if fakeNodePreGyp
			cmd += " --module_name=#{preGyp.module_name}"
			cmd += " --module_path=#{preGyp.module_path}"

		console.log "> #{cmd}".lightBlue unless program.quiet
		child = exec cmd,
			cwd: "node_modules/#{module}"
			#env:
			#	HOME: '~/.atom-shell-gyp'
		child.stdout.pipe process.stdout unless program.quiet
		child.stderr.pipe process.stderr
		child.on 'exit', (code) ->
			return cb?(new Error "node-gyp rebuild error") if code isnt 0
			#console.log "ok".green
			unless fakeNodePreGyp
				# we move the node_module.node file to lib/binding
				try fs.mkdirSync "node_modules/#{module}/lib/binding"
				fs.renameSync "node_modules/#{module}/build/Release/node_#{module}.node", "node_modules/#{module}/lib/binding/node_#{module}.node"
			rmDirRecursiveSync "node_modules/#{module}/build/"
			return cb?()
		return
	return

module.exports.installModule = (module, program, cb) ->
	console.log "installing #{module or 'all'}" unless program.quiet
	fetchModule module, program, (err) ->
		return cb?(err) if err
		buildModule module, program, (err) ->
			return cb?(err)
		return
	return
