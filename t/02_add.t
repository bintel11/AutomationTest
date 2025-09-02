use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# Add new user
$t->post_ok('/add' => form => { name => 'TestUser', email => 'test@example.com' })
  ->status_is(200)
  ->content_like(qr/^Added ID \d+: TestUser \(test\@example\.com\)$/);

# Duplicate user should fail
$t->post_ok('/add' => form => { name => 'TestUser', email => 'test@example.com' })
  ->status_is(409)
  ->content_like(qr/^Record already exists with ID \d+/);

done_testing();
