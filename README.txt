App::Blurble

Antisocial Media (TM)

* Everything is private.
* Write blurbs to yourself, read them anywhere.
* (eventually) fun

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
carton exec prove -lv
carton exec script/init_schema.pl
carton exec script/app_blurble daemon -l http://*:8000  # or your favorite Mojolicious::Command



TODO:
* make blurbles bounce (see included bounce.html for proof of concept)
* csrf hardening
* change password (keep old hashes? encrypted old passwords with new password)
    * password needs an order field
    * password n encrypts password n-1
    * you can recover old passwords with current password?
    * passwords are used to encrypt blurbs.
    * blurbs are re-encrypted when new passwords are added. Double encryption, I guess. Encryption needs to encode order # of secret used to encrypt
* README (it sucks)
* pod
* turn on taint and clean up
* mojo form validation for all forms
    * users#create
    * login#login
* GMT is great, but it should convert it to local time
* build and deploy script
* handle failed blurb deletes (e.g. session expired)
* add pagination to front end
* add columns to blurble


FUTURE FEATURES:
* wife wants a share button. Must know other user's handle, and other user must
  accept. Must then display blurb author's name. Need a new field on blurb for
  author.
* maybe along those same lines, organized blurbles, each containing blurbs,
  some being shared with other users.
* ...and since they're being shared, why not a websocket? let shared blurbs
  explode onto the screen... maybe peek out from the corner like shy children
* something involving Minion (grid server), just for fun (probably an indexer)
* configurations for LDAP or WebAuthn
* bubbles
* pagination
* blurb counter
* "fun" levers (reverse text, turn it upside down)
* grab, drag, and burn
* datetime, geolocation inputs
* indexing
* encrypted blurbs (webmaster has no business reading user blurbs)
* fork me on github
* download as text file
* download as other kinds of file
* input base64, view image, video, or other
* As::Method, once it's on CPAN
* change password
* email validation
* captcha
* blurbs are bubble. Click them to expand and read, like a modal
* cowboys that steal blurbs
* frogs that lay blurb eggs
* ML that attaches funny pictures to blurbs based on content
* a real backend database
* some days blurbs are fruit, some days sports equipment, some days christmas presents

License:
TBD. All rights reserved.
