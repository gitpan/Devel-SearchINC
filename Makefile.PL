use inc::Module::Install;
include 'Module::AutoInstall';

name 'Devel-SearchINC';
all_from 'lib/Devel/SearchINC.pm';
perl_version '5.006';

build_requires 'Test::More' => '0.70';

process_templates(
    first_year => 2004,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
);

use_standard_tests(without => 'pod_coverage');
auto_install;
auto_include;
WriteAll;
