use 5.006;
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Devel::SearchINC',
    'VERSION_FROM'	=> 'lib/Devel/SearchINC.pm',
    'PREREQ_PM'		=> {
    	Test::More => 0.45,
    },
    dist                => {
        COMPRESS => 'gzip --force --best'
    },
);
