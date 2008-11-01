use inc::Module::Install;
include 'Module::AutoInstall';

name 'Devel-SearchINC';
all_from 'lib/Devel/SearchINC.pm';
perl_version '5.006';

requires 'File::Find';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
