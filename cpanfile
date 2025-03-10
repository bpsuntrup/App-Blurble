requires 'perl', '5.36.0';
requires 'Mojolicious';
requires 'DBI';
requires 'DBD::SQLite';
requires 'aliased';
requires 'Sub::Name';
requires 'File::Slurp';
requires 'Mojolicious::Plugin::TtRenderer';
requires 'Moose';
requires 'Scope::Guard';
requires 'Template';

on 'test' => sub {
  requires 'Test::More';
  requires 'Test::Mojo::WithRoles';
  requires 'Test::Mojo::Role::Debug';
};
