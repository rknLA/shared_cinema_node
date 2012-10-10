
{exec} = require 'child_process'

REPORTER = 'min'

task 'test', 'run tests', ->
  exec "NODE_ENV=test
    PORT=3001
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script
    --require test/test_helper.coffee
    --colors
  ", (err, output) ->
    console.log output
    throw err if err
