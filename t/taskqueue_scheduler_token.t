#!/usr/bin/perl

use Test::More tests => 10;

use strict;
use warnings;

use File::Spec ();
use File::Path ();
use cPanel::TaskQueue::Scheduler;

my $statedir = File::Spec->tmpdir() . '/taskqueue';

# In case the last test did not succeed.
cleanup();

my $sched = cPanel::TaskQueue::Scheduler->new(
    { name => 'tasks', state_dir => $statedir }
);

my $token = $sched->get_token();
ok( defined $token, 'Can get a token.' );

my $sched2 = cPanel::TaskQueue::Scheduler->new( {token=>$token} );
isa_ok( $sched2, 'cPanel::TaskQueue::Scheduler', 'Recreated from token.' );
is( $sched2->get_name(), $sched2->get_name(), 'Names are the same.' );

# Although there is no guarantee that the token format will remain, it is still
# necessary to verify the error checking.
# The following tests will change when the token format changes.

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> ''} );
};
like( $@, qr/Invalid token./, 'empty token is not valid.' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'connie'} );
};
like( $@, qr/Invalid token./, 'empty token is not valid.' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'tqsched1'} );
};
like( $@, qr/Invalid token./, 'No second part' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'tqsched1:|:'} );
};
like( $@, qr/Invalid token./, 'No third part' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'xyzzy:|:fred:|:tasks_sched.yaml'} );
};
like( $@, qr/Invalid token./, 'Version does not match' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'tqsched1:|:fred:|:tasks_sched.yaml'} );
};
like( $@, qr/Invalid token./, 'Name does not match' );

eval {
    cPanel::TaskQueue::Scheduler->new( {token=> 'tqsched1:|:tasks|:fred_sched.yaml'} );
};
like( $@, qr/Invalid token./, 'File does not match' );

# Clean up after myself
sub cleanup {
    foreach my $file ( 'tasks_sched.yaml', 'task_sched.yaml.lock' ) {
        unlink "$statedir/$file" if -e "$statedir/$file";
    }
    File::Path::rmtree( $statedir ) if -e $statedir;
}
