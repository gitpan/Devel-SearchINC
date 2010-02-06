use Test::More tests => 3;

BEGIN {
    use_ok('Devel::SearchINC', 't/lib', ':debug');
    use_ok('C::D::F');
}
is(C::D::F::answer(), 42, 'C::D::F::answer is 42');
