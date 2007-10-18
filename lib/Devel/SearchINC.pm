package Devel::SearchINC;

use 5.006;
use strict;
use warnings;


our $VERSION = '1.32';


BEGIN {
    unshift @INC, sub {
        my ($self, $file) = @_;
        my ($guess, $found);

        our $DEBUG;
        printf "%s: looking for <%s>\n", __PACKAGE__, $file if $DEBUG;

        for my $path (our @paths) {

            printf "%s: path = <%s>\n", __PACKAGE__, $path
                if $DEBUG;

            # A/B.pm might be found in A/B/B.pm
            ($guess = "$path/$file") =~
                s!(.*)/(.*?)\.pm$!$1/$2/$2.pm!;

            printf "%s: guess = <%s>\n", __PACKAGE__, $guess
                if $DEBUG;

            if (-f $guess) {
                $found = $guess;
                last;
            }

            # ... or maybe in A/B/lib/A/B.pm
            # or any of the intermediary directories.
            # After all, it could be that A is the family
            # of modules, so it would be found in A/lib/A/B.pm.

            (my $module = $file) =~ s/\.pm$//;
            my $modpath = '';
            for my $part (split /\// => $module) {
                $modpath .= '/' if $modpath;
                $modpath .= $part;
                $guess = "$path/$modpath/lib/$file";

                printf "%s: guess = <%s>\n", __PACKAGE__, $guess
                    if $DEBUG;

                if (-f $guess) {
                    $found = $guess;
                    last;
                }
            }
        }

        # decline if we haven't found any files
        unless (defined $found) {
            printf "%s: nothing found, declining\n", __PACKAGE__
                if $DEBUG;

            return;
        }

        printf "%s: found <%s>\n", __PACKAGE__, $found if $DEBUG;

        if (open(my $fh, '<', $found)) {
            return $fh;
        }

        printf "%s: can't open <%s>, declining\n", __PACKAGE__, $found
            if $DEBUG;

        return;
    }
}

sub import {
    my $pkg = shift;
    our $DEBUG = 0;
    for my $path (@_) {
        if ($path eq ':debug') {
            $DEBUG = 1;
            next;
            };
        push our @paths => $path;
    }
}

1;

__END__

=head1 NAME

Devel::SearchINC - loading Perl modules from their development dirs

=head1 SYNOPSIS

  use Devel::SearchINC '/my/dev/dir';
  use My::Brand::New::Module;

=head1 DESCRIPTION

When developing a new module, I always start with

    h2xs -XA -n My::Module

This creates a directory with a useful skeleton for the module's
distribution. The directory structure is such, however, that you have
to install the module first (with C<make install>) before you can use it
in another program or module. For example, bringing in a module like so:

    use My::Module;

requires the module to be somewhere in a path listed in C<@INC>, and
the relative path is expected to be C<My/Module.pm>. However, C<h2xs>
creates a structure where the module ends up in C<My/Module/Module.pm>.

This module tries to compensate for that. The idea is that you C<use()>
it right at the beginning of your program so it can modify C<@INC> to look
for modules in relative paths of the special structure mentioned above,
starting with directories specified along with the C<use()> statement
(i.e. the arguments passed to this module's C<import()>).

This is useful because with this module you can test your programs using
your newly developed modules without having to install them just so you
can use them. This is especially advantageous when you consider working
on many new modules at the same time.

If our fictional module isn't found in C<My/Module/Module.pm>, we
try to find it in C<My/Module/lib/My/Module.pm>, which might be
the case if it's part of a larger family of modules that takes
advantage of C<ExtUtils::MakeMaker>'s C<PMLIBDIRS> mechanism.

To automatically make your development modules available to all
your scripts, you can place the following in your C<.bashrc> (or
your shell initialization file of choice):

  export PERL5OPT=-MDevel::SearchINC=/my/dev/dir

Since the syntax for this is buried in the perlrun manpage, you
might consider adding this example to the C<Devel::SearchINC> docs.

Note that there is a small limitation for the C<PERL5OPT> approach:
development modules can't be loaded via C<-M> on the perl command
line.  So the following won't work:

  $ export PERL5OPT=-MDevel::SearchINC=/my/dev/dir
  $ perl -MMy::Brand::New::Module -e'print "hello world\n"'

This is probably because C<PERL5OPT> options are appended to the
perl command line, and processed after the actual command line
options.

Also, the C<PERL5OPT> variable is ignored when Taint checks are
enabled.

=head1 MULTIPLE DEVELOPMENT DIRECTORIES

You can have multiple development directories. Just list them when using
this module:

  use Devel::SearchINC qw(/my/first/dir my/second/dir);

or

  perl -MDevel::SearchINC=/my/first/dir,/my/second/dir

C<perlrun> details the syntax for specifying multiple arguments for
modules brought in with the C<-M> switch.

=head1 DEBUGGING THIS MODULE

By using C<:debug> as one of the development directories, you can turn
on debugging. Note that despite the leading colon, this has nothing to
do with C<Exporter> semantics. With debugging activated, this module
will print detailed information while trying to find the requested file.

For example

  use Devel::SearchINC qw(/my/first/dir my/second/dir :debug);

or

  perl -MDevel::SearchINC=/my/first/dir,:debug,/my/second/dir

The C<:debug> option can be specified anywhere in the list of development
directories.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<develsearchinc> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-devel-searchinc@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

