#!/usr/bin/perl

# Test the cPanel::TaskQueue module.
#

use strict;

use Test::More tests => 2;
use cPanel::TaskQueue;
use File::Spec ();

my $missing_dir = File::Spec->tmpdir() . '/task_queue_test';

# In case the last test did not succeed.
cleanup();

# Test queue directory creation.
ok( cPanel::TaskQueue->new( { name => 'tasks', state_dir=> $missing_dir } ), 'Cache created with missing dir' );
ok( -d $missing_dir, 'created the state directory' );
cleanup();


# Clean up after myself
sub cleanup {
    foreach my $file ( 'tasks_queue.yaml', 'tasks_queue.yaml.lock' ) {
        unlink "$missing_dir/$file" if -e "$missing_dir/$file";
    }
    rmdir $missing_dir if -d $missing_dir;
}
