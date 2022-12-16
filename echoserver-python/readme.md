I asked ChatGPT the following:

> Provide python code for a tcp echo server that can accept at least 5 connections from unique hosts at once.  For each request that the server receives, it should send the data stream back to the client along with the plain text "This is an echo."  The server should also have a console where the administrator can type "exit" on standard input and the server will terminate any active connections and shut down.

It responded with the attached code.

This has not been tested but it looks like it should work; if not, it should work with some tweaking.
