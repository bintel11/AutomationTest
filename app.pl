#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";   # add ./lib to @INC
use MyMojoApp;

# Start the Mojolicious application
MyMojoApp->new->start;
