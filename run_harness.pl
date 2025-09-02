use strict;
use warnings;
use Test::Harness;

# Get all test files but ignore those starting with '_'
my @tests = grep { $_ !~ m{/_[^/]+\.t$} } glob('t/*.t');

runtests(@tests);
