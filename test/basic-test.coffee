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

	describe 'native modules', ->
		
		it 'should build "printer" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'printer',
				quiet: yes
				target: '0.17.2',
				arch: 'ia32',
			, (err) ->
				done(err)

		it 'should build "printer" for as-0.17.2 x64', (done) ->
			aspm.installModule 'printer',
				quiet: yes
				target: '0.17.2',
				arch: 'x64',
			, (err) ->
				done(err)

		it 'should build "printer" for as-0.19.5 ia32', (done) ->
			aspm.installModule 'printer',
				quiet: yes
				target: '0.19.5',
				arch: 'ia32',
			, (err) ->
				done(err)

		it 'should build "sqlite3" for as-0.17.2 ia32', (done) ->
			aspm.installModule 'sqlite3',
				quiet: yes
				target: '0.17.2',
				arch: 'ia32',
			, (err) ->
				done(err)

		###
		it 'should build sqlite3 for as-0.19.5 ia32', (done) ->
			aspm.installModule 'sqlite3',
				target: '0.19.5',
				arch: 'ia32',
			, (err) ->
				done(err)
		###