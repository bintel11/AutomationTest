use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# First add a record to update
$t->post_ok('/add' => form => { name => 'UserToUpdate', email => 'update@example.com' });
my ($id) = $t->tx->res->body =~ /Added ID (\d+):/;

# Update it
$t->put_ok("/update/$id" => form => { new_name => 'UpdatedUser', new_email => 'updated@example.com' })
  ->status_is(200)
  ->content_is("Updated ID $id: UpdatedUser (updated\@example\.com)");

done_testing();
