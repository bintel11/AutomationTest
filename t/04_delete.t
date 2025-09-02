use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# Add a record to delete
$t->post_ok('/add' => form => { name => 'UserToDelete', email => 'delete@example.com' });
my ($id) = $t->tx->res->body =~ /Added ID (\d+):/;

# Delete it
$t->delete_ok("/delete/$id")
  ->status_is(200)
  ->content_is("Deleted item with ID: $id");

# Delete again should fail
$t->delete_ok("/delete/$id")
  ->status_is(404)
  ->content_is("No item found with ID: $id");

done_testing();
