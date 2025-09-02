#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

# Create Test::Mojo object
my $t = Test::Mojo->new('MyMojoApp');

# ---------------------------
# CRUD & Validation Tests
# ---------------------------

# 1. Root route
$t->get_ok('/')->status_is(200)->content_is('Welcome to the Mojo App!');

# 2. Add new record
$t->post_ok('/add' => form => {name => 'TestUser', email => 'test@example.com'})
  ->status_is(200)
  ->content_like(qr/^Added ID \d+: TestUser \(test\@example\.com\)$/);

# Capture new ID
my ($id) = $t->tx->res->body =~ /Added ID (\d+):/;

# 3. Duplicate add (should fail)
$t->post_ok('/add' => form => {name => 'TestUser', email => 'test@example.com'})
  ->status_is(409)
  ->content_like(qr/^Record already exists with ID \d+: TestUser \(test\@example\.com\)$/);

# 4. Update record
$t->put_ok("/update/$id" => form => {new_name => 'TestUserUpdated', new_email => 'updated@example.com'})
  ->status_is(200)
  ->content_is("Updated ID $id: TestUserUpdated (updated\@example\.com)");

# 5. Delete record
$t->delete_ok("/delete/$id")
  ->status_is(200)
  ->content_is("Deleted item with ID: $id");

# 6. Delete non-existent (should fail)
$t->delete_ok("/delete/$id")
  ->status_is(404)
  ->content_is("No item found with ID: $id");

# 7. GET list
$t->get_ok('/list')
  ->status_is(200)
  ->json_is_array;

# 8. Validation tests for required fields
$t->post_ok('/add' => form => {email => 'no_name@example.com'})
  ->status_is(400)
  ->content_like(qr/Missing required field: name/);

$t->post_ok('/add' => form => {name => 'NoEmail'})
  ->status_is(400)
  ->content_like(qr/Missing required field: email/);

# ---------------------------
# Authorization / Middleware Tests
# ---------------------------

# Example: access protected route without auth
$t->get_ok('/protected')
  ->status_is(401)
  ->content_like(qr/Unauthorized/);

# Access with valid auth header
$t->get_ok('/protected' => headers => {Authorization => 'Bearer valid_token'})
  ->status_is(200)
  ->content_like(qr/Access granted/);

done_testing();
