###
currently not working:
* pathwatcher@*
* serialport@*
* zipfile@0.20.0
* v8-profiler@*
* sqlite3@0.20.0
* npgta3 ?

never worked:
* node-sass
* nodegit
###

os = require 'os'
fs = require 'fs'
path = require 'path'
exec = require('child_process').exec

chai = require 'chai'
expect = chai.expect
request = require 'request'

aspm = require '../lib'

platform = os.platform()

defaultTargets = '0.17.2 0.19.5 0.20.0'.split ' '
defaultArchs = 'ia32 x64'.split ' '
defaultArchs = ['ia32'] if platform is 'win32'


testModule = (moduleName, opts, cb) ->
	[moduleName] = moduleName.split '@' # get rid of version
	quiet = opts.quiet
	atomShellExe = path.join 'atom-shell', "atom-shell-v#{opts.target}-#{platform}-#{opts.arch}", 'atom'
	atomShellExe += '.exe' if platform is 'win32'
	testDir = path.join 'tmp', moduleName
	cmd = """
		env ATOM_SHELL_INTERNAL_RUN_AS_NODE=1 #{atomShellExe} -e "require('#{moduleName}'); console.log('OK: required #{moduleName}')"
	"""
	#child = exec "#{atomShellExe} #{testDir}"
	errMsg = ''
	child = exec cmd
	child.stdout.pipe process.stdout unless quiet
	unless quiet
		child.stderr.pipe process.stderr
	else
		child.stderr.on 'data', (chunk) -> errMsg += chunk; return
	child.on 'exit', (code) ->
		return cb?(new Error "command failed: #{cmd}\n#{errMsg}") if code isnt 0
		cb?()
	return

testInstallMulti = (moduleName, targets=defaultTargets, archs=defaultArchs, opts={}) ->
	for target in targets
		for arch in archs
			currentOpts = {}
			currentOpts[key] = val for key, val of opts # copy opts
			currentOpts.target = target
			currentOpts.arch = arch
			
			testInstall moduleName, currentOpts
	return

testInstall = (moduleName, opts={}) ->
	opts.quiet = yes unless '--verbose' in process.argv
	msg = moduleName
	msg += " for Atom-Shell@#{opts.target} on #{platform} #{opts.arch}" if opts.target and opts.arch
	msg += " from #{opts.tarball}" if opts.tarball
	it msg, (done) ->
		process.chdir opts.cwd if opts.cwd
		aspm.installModule moduleName, opts, (err) ->
			return done err unless opts.target and opts.arch
			testModule moduleName, opts, (err) ->
				return done err
			return
		return
	return

downloadAtomShellMulti = (targets=defaultTargets, archs=defaultArchs, opts={}) ->
	for target in targets
		for arch in archs
			do (target, arch) ->
				it "#{target} #{platform} #{arch}", (done) -> downloadAtomShell target, arch, done
	return

downloadAtomShell = (target, arch, cb) ->
	try fs.mkdirSync 'atom-shell'
	releaseName = "atom-shell-v#{target}-#{platform}-#{arch}"
	dir = path.join 'atom-shell', releaseName
	return cb() if fs.existsSync dir # skip if we already have it
	url = "https://github.com/atom/atom-shell/releases/download/v#{target}/#{releaseName}.zip"
	zipfileName = path.join 'atom-shell', "#{releaseName}.zip"
	zipfile = fs.createWriteStream zipfileName
	request(url).pipe(zipfile).on 'finish', ->
		zipfile.close ->
			exec "unzip #{zipfileName} -d #{dir}", (err) ->
				fs.unlink zipfileName, cb
				return
			return
		return
	return


describe 'download atom-shell', ->
	@timeout 1000*60 * 5 # minutes

	downloadAtomShellMulti()

describe 'build', ->
	@timeout 1000*60 * 3 # minutes

	describe 'js-only module', ->
		testInstall 'async'

	# !!! first enable recursive building
	#describe 'js-only module /w native dependency', ->
	#	testInstallMulti 'nino@0.1.2'

	describe 'native module', ->
		testInstallMulti 'time@0.11.0'
		testInstallMulti 'leveldown@1.0.0'
		testInstallMulti 'nslog@1.0.1'
		testInstallMulti 'pathwatcher@2.3.5'
		# testInstallMulti 'node-sass@1.2.3'

	describe 'native module /w node-pre-gyp', ->
		# testInstallMulti 'nodegit@0.2.4'
		testInstallMulti 'serialport@1.4.9'
		testInstallMulti 'zipfile@0.5.4'
		testInstallMulti 'v8-profiler@5.2.1'
		testInstallMulti 'sqlite3@3.0.4', ['0.17.2']
		testInstallMulti 'sqlite3@master', ['0.19.5', '0.20.0'], null, tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'

	describe 'node-pre-gyp test app', ->
		testInstallMulti 'node-pre-gyp-test-app1', null, null, tarball: 'test/node-pre-gyp/app1.tar.gz'
		testInstallMulti 'node-pre-gyp-test-app3', null, null, tarball: 'test/node-pre-gyp/app3.tar.gz'
