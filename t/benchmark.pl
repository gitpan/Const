#!perl
#
# $Id: benchmark.pl,v 0.1 2008/06/26 22:26:16 dankogai Exp dankogai $
#
use strict;
use warnings;
use Benchmark qw/timethese cmpthese/;
use Const;
use Readonly;

no warnings;

cmpthese(
    timethese(
        1e5,
        {
            Const    => sub { Const my $s    => 1; },
            Readonly => sub { Readonly my $s => 1; },
            constant => sub { require constant; constant->import( s => 1 ) },
            glob => sub { local *s = \1 },
            literal => sub { my $s = 1 },
        }
    )
);

sub array { 1 .. 1000 }
cmpthese(
    timethese(
        1e3,
        {
            Const    => sub { Const my @a    => array() },
            Readonly => sub { Readonly my @a => array() },
            glob => sub { local *a = [array()] },
            literal => sub { my @a = array() },
        }
    )
);

sub hash {
    map { $_ => '1' x $_ } array();
}

cmpthese(
    timethese(
        1e3,
        {
            Const    => sub { Const my %h    => hash() },
            Readonly => sub { Readonly my %h => hash() },
            glob => sub { local *a = {hash()} },
            literal => sub { my %h = hash() },
        }
    )
);
