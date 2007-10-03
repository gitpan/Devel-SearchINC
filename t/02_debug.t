use Test::More tests => 3;

BEGIN {
    use_ok('Devel::SearchINC', 't/lib', ':debug');
    use_ok('A::B');
}

is(A::B::answer(), 42, 'A::B::answer is 42');
