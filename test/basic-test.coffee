#build-printer.coffee

os = require 'os'
chai = require 'chai'
expect = chai.expect

aspm = require '../lib'

platform = os.platform()

testInstall = (moduleName, opts={}) ->
	opts.quiet = yes
	msg = "should install '#{moduleName}'"
	msg += " for Atom-Shell@#{opts.target} on #{platform} @#{opts.arch}" if opts.target and opts.arch
	msg += " from #{opts.tarball}" if opts.tarball
	it msg, (done) ->
		aspm.installModule moduleName, opts, (err) ->
			done err


describe 'build', ->
	@timeout 1000*60*30
	
	describe 'js-only modules', ->
		testInstall 'async'

	describe 'native modules', ->
		# time
		testInstall 'time@0.11.0', target: '0.17.2', arch: 'ia32'
		testInstall 'time@0.11.0', target: '0.17.2', arch: 'x64'
		testInstall 'time@0.11.0', target: '0.19.5', arch: 'ia32'
		testInstall 'time@0.11.0', target: '0.19.5', arch: 'x64'
		# leveldown
		testInstall 'leveldown@1.0.0', target: '0.17.2', arch: 'ia32'
		testInstall 'leveldown@1.0.0', target: '0.17.2', arch: 'x64'
		testInstall 'leveldown@1.0.0', target: '0.19.5', arch: 'ia32'
		testInstall 'leveldown@1.0.0', target: '0.19.5', arch: 'x64'
		###
		# node-sass
		testInstall 'node-sass@1.2.3', target: '0.17.2', arch: 'ia32'
		testInstall 'node-sass@1.2.3', target: '0.17.2', arch: 'x64'
		testInstall 'node-sass@1.2.3', target: '0.19.5', arch: 'ia32'
		testInstall 'node-sass@1.2.3', target: '0.19.5', arch: 'x64'
		###

	describe 'native modules that use node-pre-gyp', ->
		
		###
		# nodegit
		testInstall 'nodegit@0.2.4', target: '0.17.2', arch: 'ia32'
		testInstall 'nodegit@0.2.4', target: '0.17.2', arch: 'x64'
		testInstall 'nodegit@0.2.4', target: '0.19.5', arch: 'ia32'
		testInstall 'nodegit@0.2.4', target: '0.19.5', arch: 'x64'
		###

		# sqlite3
		testInstall 'sqlite3@3.0.4', target: '0.17.2', arch: 'ia32'
		testInstall 'sqlite3@3.0.4', target: '0.17.2', arch: 'x64'
		testInstall 'sqlite3', target: '0.19.5', arch: 'ia32', tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
		testInstall 'sqlite3', target: '0.19.5', arch: 'x64', tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
