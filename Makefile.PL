# Note: this file was auto-generated by Module::Build::Compat version 0.4205
use ExtUtils::MakeMaker;
WriteMakefile
(
  'PL_FILES' => {},
  'INSTALLDIRS' => 'site',
  'NAME' => 'NGS::Tools::Samtools',
  'EXE_FILES' => [
                   'bin/create_samtools_mpileup.pl',
                   'bin/create_samtools_pileup.pl'
                 ],
  'VERSION_FROM' => 'lib/NGS/Tools/Samtools.pm',
  'PREREQ_PM' => {
                   'Test::More' => 0
                 }
)
;
