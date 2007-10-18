package Devel::SearchINC::FindLib;

use strict;
use warnings;
use File::Find;


our $VERSION = '1.32';


sub import {
    my $pkg = shift;
    for my $path (@_) {
        find(sub {
            return unless -d;

            if ($_ eq 't' || $_ eq 'CVS' || $_ eq '.svn' || $_ eq 'blib') {
                $File::Find::prune = 1;
                return;
            }

            if ($_ eq 'lib') {
                $File::Find::prune = 1;
                unshift @INC, $File::Find::name;
            }
        }, $path);
    }
    unshift @INC, split /:/ => $ENV{SEARCHINC_FIRST}
        if defined $ENV{SEARCHINC_FIRST};
}


1;
