Fixture = require './lib/fixture'
{cleanSlate, prepare, always, clear, eventually, shouldFail} = require './lib/utils'
should = require 'should'
{ setupBundle} = require './lib/mock'
{bothTests, unitTests} = require './lib/segregation'

IDENTIFIERS = """
anne, "brenda"
carol
"David Brent" Edgar
rubbishy identifiers
Fatou
"""

bothTests() && describe 'Service', ->

  {service} = new Fixture()

  setupBundle 'list-upload.1.json'

  @beforeAll cleanSlate service
  @slow 500


  unitTests() && describe '#createList()', ->

    it 'should fail', shouldFail service.createList

  # BOTH
  bothTests() && describe '#createList(opts, ids)', ->

    opts =
      name: 'temp-list-uploaded'
      type: 'Employee'
      description: 'A list created to test the list upload mechanism'
      tags: ['temp', 'imjs', 'test', 'node']

    cleanUp = clear service, opts.name

    @beforeAll prepare -> cleanUp().then -> service.createList opts, IDENTIFIERS
    @afterAll always cleanUp

    it 'should have succeeded', eventually -> true

    it 'should yield a list', eventually should.exist

    it 'should have the right name', eventually (list) ->
      list.name.should.equal opts.name

    it 'should have the right number of members', eventually (list) ->
      list.size.should.equal 5

    it 'should have the right tags', eventually (list) ->
      list.hasTag(t).should.be.true for t in opts.tags

  # BOTH
  bothTests() && describe '#createList(opts-id-array, ids)', ->

    ids = [
      "anne", "brenda", "carol",
      "David Brent", "Edgar",
      "rubbishy", "identifiers",
      "Fatou"
    ]
    opts =
      name: 'temp-list-uploaded'
      type: 'Employee'
      description: 'A list created to test the list upload mechanism'
      tags: ['temp', 'imjs', 'test', 'node']

    cleanUp = clear service, opts.name

    @beforeAll prepare -> cleanUp().then -> service.createList opts, ids
    @afterAll always cleanUp

    it 'should have succeeded', eventually -> true

    it 'should yield a list', eventually should.exist

    it 'should have the right name', eventually (list) ->
      list.name.should.equal opts.name

    it 'should have the right number of members', eventually (list) ->
      list.size.should.equal 5

    it 'should have the right tags', eventually (list) ->
      list.hasTag(t).should.be.true for t in opts.tags

