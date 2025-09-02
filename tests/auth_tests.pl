#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Mojo;

# Initialize Test::Mojo with main app
my $t = Test::Mojo->new('MyMojoApp');

# -----------------------------
# Test 1: Public route works
# -----------------------------
$t->get_ok('/')->status_is(200)->content_is('Welcome to the Mojo App!');

# -----------------------------
# Test 2: Unauthorized GET /protected/list
# -----------------------------
$t->get_ok('/protected/list')
  ->status_is(401)
  ->content_is('Unauthorized');

# -----------------------------
# Test 3: Unauthorized POST /protected/add
# -----------------------------
$t->post_ok('/protected/add' => form => { name => 'NoAuth', email => 'noauth@example.com' })
  ->status_is(401)
  ->content_is('Unauthorized');

# -----------------------------
# Test 4: Authorized GET /protected/list
# -----------------------------
$t->get_ok('/protected/list' => { Authorization => 'Bearer mysecrettoken' })
  ->status_is(200)
  ->content_type('application/json');

my $json = eval { $t->tx->res->json } || [];
ok(ref $json eq 'ARRAY', 'Authorized /protected/list returns JSON array');

# -----------------------------
# Test 5: Authorized POST /protected/add
# -----------------------------
$t->post_ok('/protected/add' => 
    { Authorization => 'Bearer mysecrettoken' },
    form => { name => 'AuthUser', email => 'auth@example.com' }
  )
  ->status_is(200)
  ->content_like(qr/^Added AuthUser/);

done_testing();
