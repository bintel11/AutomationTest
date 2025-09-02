use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";
use MyMojoApp;

my $t = Test::Mojo->new('MyMojoApp');

# Root route test
$t->get_ok('/')
  ->status_is(200, 'Root returns 200')
  ->content_is('Welcome to the Mojo App!', 'Correct welcome text');

done_testing();
