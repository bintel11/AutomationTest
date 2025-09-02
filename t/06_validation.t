#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use Test::Mojo;
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# Test 1: Missing name
$t->post_ok('/add' => form => {email => 'test@example.com'})
  ->status_is(400)
  ->content_like(qr/Missing required field: name/, 'Missing name');

# Test 2: Missing email
$t->post_ok('/add' => form => {name => 'TestUser'})
  ->status_is(400)
  ->content_like(qr/Missing required field: email/, 'Missing email');

# Test 3: Missing both name and email
$t->post_ok('/add' => form => {})
  ->status_is(400)
  ->content_like(qr/Missing required field: name/, 'Missing both fields returns name error');

# Test 4: Valid add (capture ID safely)
$t->post_ok('/add' => form => {name => 'ValidUser', email => 'valid@example.com'})
  ->status_is(200)
  ->content_like(qr/^Added ID \d+: ValidUser \(valid\@example\.com\)$/, 'Valid add works');

my $id = eval { ($t->tx->res->body =~ /Added ID (\d+):/)[0] };
ok(defined $id, 'Captured ID from valid add');

# Test 5: Duplicate add
$t->post_ok('/add' => form => {name => 'ValidUser', email => 'valid@example.com'})
  ->status_is(409)
  ->content_like(qr/Record already exists with ID \d+: ValidUser \(valid\@example\.com\)/, 'Duplicate returns 409');

# Test 6: Cleanup - delete added record (skip if $id undefined)
if ($id) {
    $t->delete_ok("/delete/$id")
      ->status_is(200)
      ->content_like(qr/Deleted item with ID: $id/, 'Cleanup delete works');
}

done_testing();
