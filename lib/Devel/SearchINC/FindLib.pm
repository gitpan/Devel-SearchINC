package Devel::SearchINC::FindLib;

use strict;
use warnings;
use File::Find;


our $VERSION = '1.33';


sub import {
    my $pkg = shift;

    my @found;
    for my $path (@_) {

        # Allow paths to be separated by semicolons as well as colons;
        # splitting along colons is done by perl already.

        my @path =
            map { s/^~/$ENV{HOME}/; $_ }
            split /\s*;\s*/ =>
            $path;

        find(sub {
            return unless -d;

            if (/^t|CVS|\.svn|skel|_build$/) {
                $File::Find::prune = 1;
                return;
            }

            # lib before blib because we're unshifting and if both exist, we
            # want blib to be found first
            if ($File::Find::name =~ m!/(lib|blib/(lib|arch))$!) {
                unshift @found, $File::Find::name;
                $File::Find::prune = 1;
                return;
            }

        }, @path);

        # a simple alphabetical sort is enough for now because 'blib' sorts
        # before 'lib'. If requirements get more complicated, use a
        # Schwartzian Transform

        unshift @INC, sort @found;
    }
    unshift @INC, split /:/ => $ENV{SEARCHINC_FIRST}
        if defined $ENV{SEARCHINC_FIRST};
}


1;


__END__



=head1 NAME

Devel::SearchINC::FindLib - Find lib/ directories and prepend them to @INC

=head1 SYNOPSIS

    Devel::SearchINC::FindLib->new;

=head1 DESCRIPTION

None yet.

=head1 METHODS

=over 4



=back

Devel::SearchINC::FindLib inherits from .

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<develsearchinc> tag.

=head1 VERSION 
                   
This document describes version 1.33 of L<Devel::SearchINC::FindLib>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-devel-searchinc@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2008 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

