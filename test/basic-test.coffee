#build-printer.coffee

chai = require 'chai'
expect = chai.expect

aspm = require '../lib'

describe 'build', ->
	@timeout 1000*60*30
	
	describe 'js-only modules', ->

		it 'should install "async"', (done) ->
			aspm.installModule 'async',
				quiet: yes
			, (err) ->
				done(err)

	###
	describe 'native modules', ->
		
		it 'should build "sqlite3@3.0.4" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'sqlite3',
				quiet: yes
				target: '0.17.2'
				arch: 'ia32'
			, (err) ->
				done(err)
	###

	describe 'native modules that use node-pre-gyp', ->
		
		it 'should build "nodegit@0.2.4" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'nodegit@0.2.4',
				quiet: yes
				target: '0.17.2'
				arch: 'ia32'
			, (err) ->
				done(err)

		it 'should build "time@0.11.0" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'time@0.11.0',
				quiet: yes
				target: '0.17.2'
				arch: 'ia32'
			, (err) ->
				done(err)

		it 'should build "nodegit@0.2.4" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'sqlite3@0.2.4',
				quiet: yes
				target: '0.17.2'
				arch: 'ia32'
			, (err) ->
				done(err)

		it 'should build "sqlite3@3.0.4" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'sqlite3@3.0.4',
				quiet: yes
				target: '0.17.2'
				arch: 'ia32'
			, (err) ->
				done(err)

		it 'should build "sqlite3@3.0.4" for as-0.17.2 x64', (done) ->
			aspm.installModule 'sqlite3@3.0.4',
				quiet: yes
				target: '0.17.2'
				arch: 'x64'
			, (err) ->
				done(err)

		it 'should build "sqlite3@3.0.4" for as-0.19.5 ia32', (done) ->
			aspm.installModule 'sqlite3@3.0.4',
				quiet: yes
				target: '0.19.5'
				arch: 'ia32'
			, (err) ->
				done(err)

		it 'should build "sqlite3@3.0.4" for as-0.19.5 x64', (done) ->
			aspm.installModule 'sqlite3@3.0.4',
				quiet: yes
				target: '0.19.5'
				arch: 'x64'
			, (err) ->
				done(err)

		it 'should build "sqlite3@master" for as-0.19.5 ia32', (done) ->
			aspm.installModule 'sqlite3',
				quiet: yes
				target: '0.19.5'
				arch: 'ia32'
				tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
			, (err) ->
				done(err)

		it 'should build "sqlite3@master" for as-0.19.5 x64', (done) ->
			aspm.installModule 'sqlite3',
				quiet: yes
				target: '0.19.5'
				arch: 'x64'
				tarball: 'https://github.com/mapbox/node-sqlite3/archive/master.tar.gz'
			, (err) ->
				done(err)
