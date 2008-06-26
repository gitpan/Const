package Const;
use 5.008001;
use warnings;
use strict;

our $VERSION = sprintf "%d.%02d", q$Revision: 0.1 $ =~ /(\d+)/g;
use base 'Exporter';
our @EXPORT    = qw/Const/;
our @EXPORT_OK = qw/dlock dunlock/;
require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

sub Const(\[$@%&*]@) {
    if ( not ref $_[0] ) {
        require Carp;
        Carp::croak('prototype incorrect');
    }
    elsif ( ref $_[0] eq 'ARRAY' ) {
        @{ $_[0] } = @_[ 1 .. $#_ ];
        dlock( $_[0] );
    }
    elsif ( ref $_[0] eq 'HASH' ) {
        %{ $_[0] } = @_[ 1 .. $#_ ];
        dlock( $_[0] );
    }
    else {
        ${ $_[0] } = $_[1];
        ref $_[0] eq 'REF'
          ? dlock( ${ $_[0] } )
          : Internals::SvREADONLY( ${ $_[0] }, 1 );
    }
}

1;

=head1 NAME

Const - Facility for creating read-only variables

=head1 VERSION

$Id: Const.pm,v 0.1 2008/06/26 22:26:16 dankogai Exp dankogai $

=cut

=head1 SYNOPSIS

 use Const;
 Const my $sv => $initial_value;
 Const my @av => @values;
 Const my %hv => (key => value, key => value, ...);

 use Const qw/dlock dunlock/;
 # note parentheses and equal
 dlock( my $sv = $initial_value );
 dlock( my $ar = [@values] );
 dlock( my $hr = { key => value, key => value, ... } );
 dunlock $sv;
 dunlock $ar; dunlock \@av;
 dunlock $hr; dunlock \%hv;

=head1 DESCRIPTION

L<Const> is a drop-in replacement for L<Readonly>.  It has the same
functionality as L<Readonly> but istead of using C<tie>, it makes use
of C<SvREADONLY>.  L<Readlonly::XS> does that but only to scalars
while C<Const> recursively makes all scalars in arrays and hashes.

Note that it does not recurse on blessed references for a good reason.
Suppose

    package Foo;
    sub new { my $pkg = shift; bless { @_ }, $pkg }
    sub get { $_[0]->{foo} }
    sub set { $_[0]->{foo} = $_[1] };

And:

    Const my $o => Foo->new(foo=>1);

You cannot change $o but you can still use mutators:

    $o = Foo->new(foo => 2); # BOOM!
    $o->set(2);              # OK

If you want to make C<< $o->{foo} >> immutable, Define Foo::new like:

    sub new {
      my $pkg = shift; 
      Const my $self = { @_ }; 
      bless $self,  $pkg;
   }

Or consider using L<Moose>.

=head1 EXPORT

C<Const> by default.  C<dlock> and C<dunlock> on demand.

=head1 FUNCTIONS

=head2 Const

See L</SYNOPSIS>.

=head2 dlock

  dlock($scalar);

Locks $scalar and if $scalar is a reference, recursively locks
referents.

=head2 dunlock

Does the opposite of C<dlock>.

=head1 BENCHMARK

Unlike L <Readonly> which implements immutability via C <tie()>,
L<Const> just turns on read -only flag of the scalars so it is faster.
Check t/benchmark.pl for details.

=head2 Scalar
                Rate constant Readonly    Const  literal     glob
  constant   35461/s       --     -32%     -93%     -99%     -99%
  Readonly   52083/s      47%       --     -90%     -99%     -99%
  Const     526316/s    1384%     911%       --     -89%     -89%
  literal  5000000/s   14000%    9500%     850%       --      -0%
  glob     5000000/s   14000%    9500%     850%       0%       --

=head2 Array w/ 1000 elements

           Rate Readonly    Const  literal     glob
  Readonly 1205/s       --     -49%     -67%     -80%
  Const    2381/s      98%       --     -36%     -60%
  literal  3704/s     207%      56%       --     -37%
  glob     5882/s     388%     147%      59%       --

=head2 Hash w/ 1000 key-value pairs.

            Rate Readonly    Const  literal     glob
  Readonly 180/s       --     -35%     -41%     -59%
  Const    277/s      54%       --      -9%     -36%
  literal  305/s      70%      10%       --     -30%
  glob     433/s     141%      56%      42%       --

=head1 AUTHOR

Dan Kogai, C<< <dankogai at dan.co.jp> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-const at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Const>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Const

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Const>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Const>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Const>

=item * Search CPAN

L<http://search.cpan.org/dist/Const>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

