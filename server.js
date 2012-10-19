
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , path = require('path')
  , mongoose = require('mongoose')
  , keys = require('./keys');

require('coffee-script');

var app = module.exports = express();

var allowCORS = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', '*');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
}

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('googleApiKey', keys.googleApiKey);
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(allowCORS);
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
  app.set('db', mongoose.connect('mongodb://localhost/cinema_dev'));
});

app.configure('test', function() {
  app.set('db', mongoose.connect('mongodb://localhost/cinema_test'));
});

app.configure('production', function() {
  app.set('db', mongoose.connect(keys.mongoUrl);
});

require('./apps/videos/submission')(app)
require('./apps/videos/upvote')(app)
require('./apps/users/create')(app)
require('./apps/search/video_search')(app)

app.options('*', function(req, res) {
  res.status(200);
  res.send();
});


http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});


