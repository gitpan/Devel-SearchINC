package Devel::SearchINC;

require 5.005_62;
use strict;
use warnings;
use Data::Dumper;

our $VERSION = '0.01';

BEGIN {
	unshift @INC, sub {
		my ($self, $file) = @_;
		my $guess;
		for my $path (our @paths) {
			# A/B.pm might be found in A/B/B.pm
			($guess = "$path/$file") =~
			    s!(.*)/(.*?)\.pm$!$1/$2/$2.pm!;
			last if -f $guess;
		}

		# decline if we haven't found any files
		return unless $guess;

		local *FH;
		if (open(FH, $guess)) {
			return *FH;
		}
	}
}

sub import {
	my $pkg = shift;
	our @paths = @_;
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

=head1 TODO

=over 4

=item Test on different platforms and Perl versions.

=back

=head1 BUGS

None known so far. If you find any bugs or oddities, please do inform the
author.

=head1 AUTHOR

Marcel GrE<uuml>nauer, <marcel@codewerk.com>

=head1 COPYRIGHT

Copyright 2001 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1).

=cut
