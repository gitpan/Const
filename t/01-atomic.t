#!perl -T
#
# $Id: 01-atomic.t,v 0.1 2008/06/26 22:26:16 dankogai Exp dankogai $
#
use strict;
use warnings;
use Const;
#use Test::More 'no_plan';
use Test::More tests => 10;

Const my $s => 1;
is $s, 1, '$s => 1';
eval{ $s++ };
ok $@, $@;
Const my $c => sub { 1 };
isa_ok $c, 'CODE';
eval{ $c = sub { 0 } };
ok $@, $@;
Const my $g => \*STDIN;
isa_ok $g, 'GLOB';
eval{ $g = \*STDOUT };
ok $@, $@;
Const my $v => v1.2.3;
is $v, v1.2.3, '$v => v1.2.3';
eval{ $v = v3.4.5 };
ok $@, $@;
Const my $r => qr/[perl]/;
is $r, qr/[perl]/, '$r => qr/perl/';
eval{ $r = qr/[PERL]/ };
ok $@, $@;


__END__
SCALAR
#ARRAY
#HASH
CODE
#REF
GLOB
#LVALUE
#FORMAT
#IO
VSTRING
Regexp

