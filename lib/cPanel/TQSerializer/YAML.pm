package cPanel::TQSerializer::YAML;

# cpanel - cPanel/TQSerializer/YAML.pm            Copyright(c) 2011 cPanel, Inc.
#                                                           All rights Reserved.
# copyright@cpanel.net                                         http://cpanel.net
# This code is subject to the cPanel license. Unauthorized copying is prohibited

use YAML::Syck ();

#use warnings;
use strict;

sub load {
    my ($class, $fh) = @_;
    local $/;
    return YAML::Syck::Load( scalar <$fh> );
}

sub save {
    my ($class, $fh, @args) = @_;
    return print $fh YAML::Syck::Dump( @args );
}

sub filename {
    my ($class, $stub) = @_;
    return "$stub.yaml";
}

1;

