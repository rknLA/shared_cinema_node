global.chai = require 'chai'
global.assert = chai.assert
chai.should() # use .should

global.rest = require 'restler'
global.app = require '../server'

global.mongoose = require 'mongoose'

global.User = require '../models/user'
global.Video = require '../models/video'
