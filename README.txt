App::Blurble

Antisocial Media (TM)

* Everything is private.
* Write blurbs to yourself, read them anywhere.

Blurble is a web app that eh... you can store blurbs in.

A "blurb" is a chonk of text (utf-8). Maybe it's base64 encoded cat pictures. Maybe it's
randomly generate noise. Could just be a diary. Create a user, log in, and start
writing blurbs. They are private to you. 

This is created as a way for me to play with perl a little bit before an interview
next week. Just want to take my mind off, ease some anxiety.

How to run it:
==============
npm install 
npm exec webpack
carton install
carton exec script/app_blurble daemon -l http://*:8000  # or your favorite Mojolicious::Command

TODO:
* README (it sucks)
* pod
* tests
* turn on taint and clean up
* mojo form validation for all forms
    * users#create
    * login#login
* GMT is great, but it should convert it to local time
* build and deploy script


FUTURE FEATURES:
* wife wants a share button. Must know other user's handle, and other user must accept. Must then display blurb author's name. Need a new field on blurb for author.
* maybe along those same lines, organized blurbles, each containing blurbs, some being shared with other users.
* ...and since they're being shared, why not a websocket?
* something involving Minion (grid server), just for fun
* configurations for LDAP or WebAuthn
* download as text file
* download as other kinds of file
* input base64, view image, video, or other
* As::Method, once it's on CPAN


License:
TBD. All rights reserved.
