use inc::Module::Install;
include 'Module::AutoInstall';

name 'Devel-SearchINC';
all_from 'lib/Devel/SearchINC.pm';
perl_version '5.006';

requires 'File::Find';

test_requires 'Test::More' => '0.70';
extra_tests;

auto_install;
auto_include;
WriteAll;
