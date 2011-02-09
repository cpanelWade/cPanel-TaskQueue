#!/usr/bin/perl

# Test the cPanel::TaskQueue module.
#

use strict;
use FindBin;
use lib "$FindBin::Bin/mocks";
use File::Spec ();

use Test::More tests => 2;
use cPanel::TaskQueue;

my $statedir = File::Spec->tmpdir();

eval {
    cPanel::TaskQueue->new();
};
ok( defined $@, "Cannot create TaskQueue with no directory." );

eval {
    cPanel::TaskQueue->new( { state_dir => $statedir } );
};
ok( defined $@, "Cannot create TaskQueue with no name." );
