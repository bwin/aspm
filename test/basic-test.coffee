#build-printer.coffee

chai = require 'chai'
expect = chai.expect

aspm = require '../lib'

platform = process.platform()

testBuild = (module, opts) ->
	opts.quiet = yes
	msg = 'should build "time@0.11.0"'
	msg += " for Atom-Shell@#{opts.target} on #{platform} @#{opts.arch}" if opts.target and opts.arch
	it msg, (done) ->
		aspm.installModule 'time@0.11.0', opts, (err) ->
			done err


describe 'build', ->
	@timeout 1000*60*30
	
	describe 'js-only modules', ->
		testBuild 'async'

	describe 'native modules', ->
		# time
		testBuild 'time@0.11.0', target: '0.17.2', arch: 'ia32'
		testBuild 'time@0.11.0', target: '0.17.2', arch: 'x64'
		testBuild 'time@0.11.0', target: '0.19.5', arch: 'ia32'
		testBuild 'time@0.11.0', target: '0.19.5', arch: 'x64'
		# leveldown
		testBuild 'leveldown@1.0.0', target: '0.17.2', arch: 'ia32'
		testBuild 'leveldown@1.0.0', target: '0.17.2', arch: 'x64'
		testBuild 'leveldown@1.0.0', target: '0.19.5', arch: 'ia32'
		testBuild 'leveldown@1.0.0', target: '0.19.5', arch: 'x64'
		###
		# node-sass
		testBuild 'node-sass@1.2.3', target: '0.17.2', arch: 'ia32'
		testBuild 'node-sass@1.2.3', target: '0.17.2', arch: 'x64'
		testBuild 'node-sass@1.2.3', target: '0.19.5', arch: 'ia32'
		testBuild 'node-sass@1.2.3', target: '0.19.5', arch: 'x64'
		###

	describe 'native modules that use node-pre-gyp', ->
		
		###
		# nodegit
		testBuild 'nodegit@0.2.4', target: '0.17.2', arch: 'ia32'
		testBuild 'nodegit@0.2.4', target: '0.17.2', arch: 'x64'
		testBuild 'nodegit@0.2.4', target: '0.19.5', arch: 'ia32'
		testBuild 'nodegit@0.2.4', target: '0.19.5', arch: 'x64'
		###

		# sqlite3
		testBuild 'nodegit@0.2.4', target: '0.17.2', arch: 'ia32'
		testBuild 'nodegit@0.2.4', target: '0.17.2', arch: 'x64'
		testBuild 'nodegit@0.2.4', target: '0.19.5', arch: 'ia32', tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
		testBuild 'nodegit@0.2.4', target: '0.19.5', arch: 'x64', tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
		