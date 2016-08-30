app.get('/', function (request, response){
    response.sendFile('dist/index.html');
});

dbCall_string('/endpoint-one', 'select', multipleConnection, function(data){
    return "SELECT * FROM users WHERE firstName=" + data.firstName;
});

dbCall_file('/endpoint-two', 'select', defaultConnection, 'myQuery.sql');
