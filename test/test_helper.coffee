global.chai = require 'chai'
global.assert = chai.assert
chai.should() # use .should

global.rest = require 'restler'
global.app = require '../server'
