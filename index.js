var express = require("express");
var bodyParser = require("body-parser");
var mysql = require('mysql');
var fs = require('fs');

var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.static(__dirname));

var defaultConnection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '',
  database: 'utpDatabase'
});

var multipleConnection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'utpDatabase',
    multipleStatements: true
});

function dbCall_string(endpoint, operation, settings, construct){
    app.post(endpoint, function(request, response){
        var query,
        data = request.body;
        var connection = (settings == 'default') ? defaultConnection : settings;

        query = construct(data);

        connection.query(query, function(err, rows){
            if (!err){
                var toClient = (operation == 'select') ? rows : {success: true};
                response.send(toClient);
            } else {
                console.log(err);
                response.send({error: err, query: query});
            }
        });

    });
};

function dbCall_file (endpoint, operation, settings, filename){
    app.post(endpoint, function(request, response){
        var data = request.body;
        var path = 'dist/queries/' + filename
        var connection = (settings == 'default') ? defaultConnection : settings;
        var callback = function(arg){
            var query = arg.replace(/{{[ ]{0,2}([a-zA-Z0-9\.\_\-]*)[ ]{0,2}}}/g, function(str, mch){ return data[mch]});
            connection.query(query, function(err, rows){
                if (!err){
                    var toClient = (operation == 'select') ? rows : {success: true};
                    response.send(toClient);
                } else {
                    console.log(err);
                    response.send({error: err, query: query});
                }
            });
        };

        fs.readFile(path, 'utf8', function(err, data){
            if (!err){
                callback(data);
            } else {
                callback(err);
            }
        });

    });
};
app.get('/', function (request, response){
    response.sendFile('dist/index.html');
});

dbCall_string('/endpoint-one', 'select', multipleConnection, function(data){
    return "SELECT * FROM users WHERE firstName=" + data.firstName;
});

dbCall_file('/endpoint-two', 'select', defaultConnection, 'myQuery.sql');


app.listen(8080,function(){
	console.log("Started on PORT 8080");
});
