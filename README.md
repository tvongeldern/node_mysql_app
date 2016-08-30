This simple pre-built app is ready to go- all you need to do is hook it up to a MySQL database, fill in your username and password in head.js, and you're ready to go!

If you look into src/node/_sampleEndpoints.js, you'll see 3 basic endpoints.

The first one sends up the index.html file when it receives a get request. Basic web-server functionality.

The second endpoint receives a post- and assuming your post data has a 'firstName' attribute, it will query the database for users with the first name.

The third endpoint, perfect for more complicated queries, uses the file src/queries/myQuery.sql to get its SQL command. The variable it passes, nodeVariable, is enclosed in double curly braces inside the file. You can see in the head that the app knows to search the data object from the post for a key by that name.
