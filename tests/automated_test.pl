#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Mojo::UserAgent;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

use Test::Mojo;
my $t = Test::Mojo->new('MyMojoApp');

# ------------------------
# Test 1: Root route
# ------------------------
$t->get_ok('/')->status_is(200)->content_is('Welcome to the Mojo App!');

# ------------------------
# Test 2: POST /add (new record)
# ------------------------
$t->post_ok('/add' => form => {name => 'TestUser', email => 'test@example.com'})
  ->status_is(200)
  ->content_like(qr/^Added ID \d+: TestUser \(test\@example\.com\)$/);

my ($id) = $t->tx->res->body =~ /Added ID (\d+):/;

# ------------------------
# Test 3: POST /add (duplicate, should fail with 409)
# ------------------------
$t->post_ok('/add' => form => {name => 'TestUser', email => 'test@example.com'})
  ->status_is(409)
  ->content_like(qr/^Record already exists with ID \d+: TestUser \(test\@example\.com\)$/);

# ------------------------
# Test 4: PUT /update/:id (update existing)
# ------------------------
$t->put_ok("/update/$id" => form => {new_name => 'TestUserUpdated', new_email => 'updated@example.com'})
  ->status_is(200)
  ->content_is("Updated ID $id: TestUserUpdated (updated\@example\.com)");

# ------------------------
# Test 5: DELETE /delete/:id (delete existing)
# ------------------------
$t->delete_ok("/delete/$id")
  ->status_is(200)
  ->content_is("Deleted item with ID: $id");

# ------------------------
# Test 6: DELETE /delete/:id again (should fail with 404)
# ------------------------
$t->delete_ok("/delete/$id")
  ->status_is(404)
  ->content_is("No item found with ID: $id");

# ------------------------
# Test 7: Final GET /list (array still valid, deleted user gone)
# ------------------------
$t->get_ok('/list')->status_is(200);
my $json_final = eval { $t->tx->res->json } || [];
ok(ref $json_final eq 'ARRAY', 'Final GET /list still returns an array');
ok(
    !grep { ref $_ eq 'HASH' && $_->{id} && $_->{id} == $id } @$json_final,
    'Final GET /list confirms deleted user is gone'
);

# ------------------------
# Test 8: Non-existent route
# ------------------------
$t->get_ok('/nonexistent')->status_is(404)->content_is('Not found');

# ------------------------
# Test 9: POST /add with missing name
# ------------------------
$t->post_ok('/add' => form => { email => 'missingname@example.com' })
  ->status_is(400)
  ->content_like(qr/Missing required field: name/, 'Validation error: name is required');

# ------------------------
# Test 10: POST /add with missing email
# ------------------------
$t->post_ok('/add' => form => { name => 'NoEmailUser' })
  ->status_is(400)
  ->content_like(qr/Missing required field: email/, 'Validation error: email is required');

# ------------------------
# Test 11: POST /add with invalid email
# ------------------------
$t->post_ok('/add' => form => { name => 'BadEmailUser', email => 'not-an-email' })
  ->status_is(400)
  ->content_like(qr/Invalid email format/, 'Validation error: email format check');

# ------------------------
# Test 12: PUT /update/:id with empty values
# ------------------------
$t->put_ok("/update/$id" => form => { new_name => '', new_email => '' })
  ->status_is(400)
  ->content_like(qr/Invalid update data/, 'Validation error: update with empty fields');

# ------------------------
# Test 13: PUT /update/:id with invalid email format
# ------------------------
$t->put_ok("/update/$id" => form => { new_name => 'UserX', new_email => 'bademail' })
  ->status_is(400)
  ->content_like(qr/Invalid email format/, 'Validation error: update email format');

done_testing();
