use inc::Module::Install;
name 'Devel-SearchINC';
all_from 'lib/Devel/SearchINC.pm';

build_requires 'Test::More';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
