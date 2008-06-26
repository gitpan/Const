#!perl -T
#
# $Id: 02-avhv.t,v 0.1 2008/06/26 22:26:16 dankogai Exp dankogai $
#
use strict;
use warnings;
use Const;
#use Test::More 'no_plan';
use Test::More tests => 18;

{
    Const my @a => ( 0, 1, 2, 3 );
    is_deeply [ 0, 1, 2, 3 ], \@a, '@a => (0,1,2,3)';
    eval { shift @a };
    ok $@, $@;
    eval { $a[0]-- };
    ok $@, $@;
    Const my $a => [ 0, 1, 2, 3 ];
    is_deeply [ 0, 1, 2, 3 ], $a, '$a => [0,1,2,3]';
    eval { shift @$a };
    ok $@, $@;
    eval { $a->[0]-- };
    ok $@, $@;
    Const my $aa => [ 0, [ 1, [ 2, [3] ] ] ];
    is_deeply [ 0, [ 1, [ 2, [3] ] ] ], $aa, '$aa => [0,[1,[2,[3]]]]';
    eval { shift @$aa };
    ok $@, $@;
    eval { $aa->[0][0][0][0]-- };
    ok $@, $@;

}
{
    Const my %h => ( one => 1, two => 2 );
    is_deeply { one => 1, two => 2 }, \%h, '%h => (one=>1, two=>2)';
    eval { %h = ( three => 3 ) };
    ok $@, $@;
    eval { $h{one}-- };
    ok $@, $@;
    Const my $h => { one => 1, two => 2 };
    is_deeply { one => 1, two => 2 }, $h, '$h => {one=>1, two=>2}';
    eval { $h = { three => 3 } };
    ok $@, $@;
    eval { $h->{one}-- };
    ok $@, $@;
    Const my $hh => { one => 1, two => { be => 2 } };
    is_deeply { one => 1, two => { be => 2 } }, $hh,
	'$hh => {one=>1, two=>{be=>2}}';
    eval { $h = { three => 3 } };
    ok $@, $@;
    eval { $h->{one}{two}-- };
    ok $@, $@;
}

__END__
#SCALAR
ARRAY
HASH
#CODE
#REF
#GLOB
#LVALUE
#FORMAT
#IO
#VSTRING
#Regexp

