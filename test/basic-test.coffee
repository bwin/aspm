#build-printer.coffee

os = require 'os'
chai = require 'chai'
expect = chai.expect

aspm = require '../lib'

platform = os.platform()

#defaultTargets = '0.16.3 0.17.2 0.18.2 0.19.5'.split ' '
defaultTargets = '0.17.2 0.19.5 0.20.0'.split ' '
defaultArchs = 'ia32 x64'.split ' '

testInstallMulti = (moduleName, targets=defaultTargets, archs=defaultArchs, opts={}) ->
	for target in targets
		for arch in archs
			currentOpts = {}
			currentOpts[key] = val for key, val of opts # copy opts
			currentOpts.target = target
			currentOpts.arch = arch

			testInstall moduleName, currentOpts

testInstall = (moduleName, opts={}) ->
	opts.quiet = yes unless '--verbose' in process.argv
	msg = moduleName
	msg += " for Atom-Shell@#{opts.target} on #{platform} #{opts.arch}" if opts.target and opts.arch
	msg += " from #{opts.tarball}" if opts.tarball
	it msg, (done) ->
		process.chdir opts.cwd if opts.cwd
		command = if opts.build then aspm.buildModule else aspm.installModule
		command moduleName, opts, (err) ->
			done err

describe 'build', ->
	@timeout 1000*60 * 30 # minutes

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
		testInstallMulti 'nodegit@0.2.4'
		testInstallMulti 'serialport@1.4.9'
		testInstallMulti 'zipfile@0.5.4'
		testInstallMulti 'v8-profiler@5.2.1'
		testInstallMulti 'sqlite3@3.0.4', ['0.17.2']
		testInstallMulti 'sqlite3@master', ['0.19.5', '0.20.0'], null, tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'

	describe 'node-pre-gyp test app', ->
		testInstallMulti 'node-pre-gyp-test-app1', null, null, tarball: 'test/node-pre-gyp/app1.tar.gz'
		testInstallMulti 'node-pre-gyp-test-app3', null, null, tarball: 'test/node-pre-gyp/app3.tar.gz'
