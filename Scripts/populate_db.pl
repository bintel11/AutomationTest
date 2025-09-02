#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use MyMojoApp::Schema;
use MyMojoApp::Model::DB;

# Connect to the database
my $schema = MyMojoApp::Model::DB->schema;

# Insert some test data
$schema->resultset('User')->create({
    username => 'alice',
    email    => 'alice@example.com',
});

$schema->resultset('User')->create({
    username => 'bob',
    email    => 'bob@example.com',
});

print "Database populated with sample users.\n";
