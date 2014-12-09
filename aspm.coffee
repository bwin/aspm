
fs = require 'fs'
exec = require('child_process').exec

program = require 'commander'

pkg = require './package.json'


# from https://gist.github.com/liangzan/807712#comment-337828
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
				fs.unlinkSync filePath
			else
				rmDirRecursiveSync filePath
			i++
	fs.rmdirSync dirPath
	return

fetchModule = (module, cb) ->
	cmd = "npm install --ignore-scripts #{module}"
	console.log cmd
	child = exec cmd
	child.stdout.on 'data', (chunk) ->
		console.log chunk
		child.stderr.on 'data', (chunk) ->
		console.error chunk
	child.on 'exit', -> cb?()

buildModule = (module, target, arch, cb) ->
	cmd = "node-gyp rebuild --target=#{target} --arch=#{arch} --dist-url=https://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist"
	console.log cmd
	child = exec cmd,
		cwd: "node_modules/#{module}"
		#env:
		#	HOME: '~/.atom-shell-gyp'
	child.stdout.on 'data', (chunk) ->
		console.log chunk
	child.stderr.on 'data', (chunk) ->
		console.error chunk
	child.on 'exit', ->
		# we need to move the module.node file to lib/binding
		fs.mkdirSync "node_modules/#{module}/lib/binding"
		fs.renameSync "node_modules/#{module}/build/Release/node_#{module}.node", "node_modules/#{module}/lib/binding/node_#{module}.node"
		rmDirRecursiveSync "node_modules/#{module}/build/"
		cb?()

installModules = (module, target, arch, cb) ->
	fetchModule module, (err) ->
		buildModule module, target, arch, (err) ->
			cb?()


program
.version "v#{pkg.version}"
.description 'Manipulate asar archive files'
.option '-t, --target <n>', 'Atom-Shell version'
.option '-a, --arch <n>', 'target architecture'
.option '-s, --save', 'save as dependency to package.json'
.option '-s, --save-dev', 'save as devDependency to package.json'


# default values for options
program.target = '0.11.0'
program.arch = 'ia32'


program
.command 'install <module>'
.alias 'i'
.description 'install module (fetch & build)'
.action (module) ->
	console.log "installing ", module
	installModules module, program.target, program.arch

program
.command 'fetch <module>'
.alias 'f'
.description 'fetch module'
.action (module) ->
	console.log "fetching ", module
	fetchModule module

program
.command 'build <module>'
.alias 'b'
.description 'build module'
.action (module) ->
	console.log "building", module, program.target, program.arch
	buildModule module, program.target, program.arch


program.parse process.argv
program.help() if program.args.length is 0
