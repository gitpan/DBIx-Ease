use ExtUtils::MakeMaker;
WriteMakefile(
  'NAME' => 'DBIx::Ease',
  'AUTHOR' => 'ALPO',
  'VERSION_FROM' => 'Ease.pm',
  'PREREQ_PM' => { 'DBD::CSV' => '1', 'DBI' => '1', }
);
