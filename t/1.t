use Test::More tests => 7;

BEGIN {
    use_ok('Devel::SearchINC', 't/lib');
    use_ok('A::B');
    use_ok('C::D::F');
    use_ok('C::D::F::G');
    # use_ok('E');
}

is(A::B::answer(), 42, 'A::B::answer is 42');
is(C::D::F::answer(), 42, 'C::D::F::answer is 42');
is(C::D::F::G::answer(), 42, 'C::D::F::G::answer is 42');
# is(E::answer(), 42, 'E::answer is 42');
