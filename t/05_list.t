use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# Ensure /list returns array
$t->get_ok('/list')->status_is(200);

my $json = $t->tx->res->json;
ok(ref $json eq 'ARRAY', '/list returns a JSON array');

done_testing();
