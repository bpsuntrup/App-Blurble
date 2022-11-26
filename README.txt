App::Blurble

anti-social media
everything is private
write blurbs to yourself
maybe in the future I'll add the ability to share blurbs.

webapp that eh... you can store blurbs in.

A "blurb" is a chonk of text (utf-8). Maybe it's base64 encoded cat pictures. Maybe it's
randomly generate noise. Could just be a diary. Create a user, log in, and start
writing blurbs. They are private to you. 

This is created as a way for me to play with perl a little bit before an interview
next week. Just want to take my mind off, ease some anxiety.

Requires Mojolicious. We'll see how I choose to handle dependencies here in a minute.
there are a lot, and they're undocumented. Keep installing stuff from CPAN till it works.

useful commands:
================
to run dev server:
npm install 
npm exec webpack
script/app_blurble daemon -l http://*:8000

to autoload changes to frontend/:
npm install
npm exec webpack watch

TODO:
* README
* pod
* tests
* dockerization
* put in git server on suntrup.net
* make a cpan distribution I can install on my server
* turn on taint and clean up
* mojo form validation for all forms
    * users#create
    * login#login

* put it in home under a directory called code/, and add a new nginx location /code { proxy_pass http://localhost:8000; } block
* create hypnotoad service, get it running, add location /blurble { proxy_pass http://localhost:8080/; } to nginx config


FUTURE FEATURES:
* wife wants a share button. Must know other user's handle, and other user must accept. Must then display blurb author's name. Need a new field on blurb for author.
* maybe along those same lines, organized blurbles, each containing blurbs, some being shared with other users.
* ...and since they're being shared, why not a websocket?
* something involving Minion (grid server), just for fun
* configurations for LDAP or WebAuthn
* download as text file
* download as other kinds of file
* input base64, view image, video, or other
* Module::Methods, or As::Method, or as::method

License:
TBD. All rights reserved.
