
fs = require 'fs'
path = require 'path'
os = require 'os'
exec = require('child_process').exec

queue = require 'queue-async'
semver = require 'semver'
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

module.exports.runCmd = runCmd = (cmd, opts, quiet, cb) ->
	console.log "> #{cmd}".lightBlue unless quiet
	errMsg = ''
	child = exec cmd, opts
	child.stdout.pipe process.stdout unless quiet
	unless quiet
		child.stderr.pipe process.stderr
	else
		child.stderr.on 'data', (chunk) -> errMsg += chunk; return

	child.on 'exit', (code) ->
		return cb?(new Error "command failed: #{cmd}", errMsg) if code isnt 0
		cb?()
	return

configureModule = (moduleName, opts, nodePreGypParams, cb) ->
	cmd = "node-gyp configure #{nodePreGypParams}"

	runCmd cmd,
		cwd: "node_modules/#{moduleName}"
	, opts.quiet, cb
	return
	
module.exports.fetchModule = fetchModule = (moduleName, opts, cb) ->
	console.log "fetching #{moduleName or 'all'}" unless opts.quiet
	moduleName ?= ''
	moduleName = opts.tarball if opts.tarball
	cmd = "npm install --ignore-scripts #{moduleName}"
	cmd += ' --save' if opts.save
	cmd += ' --save-dev' if opts['save-dev']
	runCmd cmd, {}, opts.quiet, cb
	return

module.exports.buildModule = buildModule = (moduleName, opts, cb) ->
	projectPkg = require path.join process.cwd(), 'package.json'
	config = projectPkg.config?['atom-shell']
	target = opts.target or config?.version
	arch = opts.arch or config?.arch
	platform = opts['target-platform'] or config?['platform'] or os.platform()
	modules = []
	nodePreGypParams = ''

	modules = moduleName.split ' ' if moduleName.indexOf(' ') isnt -1
	modules = Object.keys projectPkg.dependencies unless moduleName

	if modules.length isnt 0
		# build multiple modules serially and return
		q = queue(1)
		for moduleName in modules
			q.defer buildModule, moduleName
			q.awaitAll (err) ->
				return cb()
		return
	
	[moduleName] = moduleName.split '@'

	# error if module is not found
	return cb?(new Error("aspm: module not found '#{moduleName}'")) unless fs.existsSync path.join process.cwd(), 'node_modules', moduleName, 'package.json'
	# skip if module has no bynding.gyp
	return cb() unless fs.existsSync path.join process.cwd(), 'node_modules', moduleName, 'binding.gyp'
	
	return cb?(new Error "aspm: no atom-shell version specified.") unless target
	return cb?(new Error "aspm: no target architecture specified.") unless arch

	buildPkg = require path.join process.cwd(), 'node_modules', moduleName, 'package.json'

	fakeNodePreGyp = buildPkg.dependencies?['node-pre-gyp']? and buildPkg.binary?
	if fakeNodePreGyp
		nodePreGypPkg = require path.join process.cwd(), 'node_modules', moduleName, 'node_modules', 'node-pre-gyp', 'package.json'
		nodePreGypVersion = nodePreGypPkg.version

		node_abi = "atom-shell-v#{target}"
		if semver.lte nodePreGypVersion, '0.6.1'
			node_abi = do ->
				atomshellToModulesVersion =
					'0.16.x': '0.11.13'
					'0.17.x': '0.11.14'
					'0.18.x': '0.11.14'
					'0.19.x': '0.11.14'
				targetParts = target.split '.'
				targetParts[2] = 'x'
				targetSimplified = targetParts.join '.'
				return "node-v#{atomshellToModulesVersion[targetSimplified]}"

		module_path = buildPkg.binary.module_path
		# fake node-pre-gyp
		module_path = module_path
		.replace '{node_abi}', node_abi
		.replace '{platform}', os.platform()
		.replace '{arch}', arch
		
		preGyp =
			module_name: buildPkg.binary.module_name
			module_path: path.join '..', module_path

	if fakeNodePreGyp
		nodePreGypParams += " --module_name=#{preGyp.module_name}"
		nodePreGypParams += " --module_path=#{preGyp.module_path}"

	configureModule moduleName, opts, nodePreGypParams, (err) ->
		console.log "building #{moduleName} for Atom-Shell v#{target} #{os.platform()} #{arch}" unless opts.quiet

		cmd = "node-gyp rebuild --target=#{target} --arch=#{arch} --target_platform=#{platform} --dist-url=https://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist #{nodePreGypParams}"

		runCmd cmd,
			cwd: "node_modules/#{moduleName}"
		, opts.quiet, (err) ->
			return cb?(err) if err
			unless fakeNodePreGyp
				# we move the node_module.node file to lib/binding
				try fs.mkdirSync "node_modules/#{moduleName}/lib/binding"
				fs.renameSync "node_modules/#{moduleName}/build/Release/node_#{moduleName}.node", "node_modules/#{moduleName}/lib/binding/node_#{moduleName}.node"
			rmDirRecursiveSync "node_modules/#{moduleName}/build/"
			return cb?()
		return
	return

module.exports.installModule = (moduleName, opts, cb) ->
	console.log "installing #{moduleName or 'all'}" unless opts.quiet
	fetchModule moduleName, opts, (err) ->
		return cb?(err) if err
		buildModule moduleName, opts, (err) ->
			return cb?(err)
		return
	return
