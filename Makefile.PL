use ExtUtils::MakeMaker;
WriteMakefile(
  'NAME' => 'DBIx::Ease',
  'AUTHOR' => 'Alexander Pourmirzayouf',
  'VERSION_FROM' => 'Ease.pm',
  'PREREQ_PM' => {'DBI' => '1',}
);