package DBIx::Ease;
# Copyright (c) 2002 Alexander Pourmirzayouf. All rights reserved.

use strict;
use DBI;
use vars qw($VERSION);
$VERSION = "0.04";

1;

sub new {
  my $class = shift;
  my $kwas = {};
  $kwas->{'drv'} = shift;
  $kwas->{'cons'} = {};
  bless $kwas, $class;
  return $kwas;
}

sub exec {
  my $self = shift;
  my $name = shift;
  my $sql = shift;
  my @sel;
  unless ($self->{'cons'}{$name}){
    unless ($self->{'drv'} ne "CSV"){
      $self->{'cons'}{$name} = DBI->connect("DBI:CSV:f_dir=$name");
    }
  }
  unless ($self->{'cons'}{$name}){return;}
  my $sth = $self->{'cons'}{$name}->prepare($sql);
  $sth->execute();
  if ($sql =~ m/^SELEC/i){
    while (my $row = $sth->fetch){push(@sel, @$row);}
    return @sel;
  }
}

sub disconnect_all {
  my $self = shift;
  my $e;
  my %kwas = %{$self->{'cons'}};
  foreach $e (keys %kwas){
    $self->{'cons'}{$e}->disconnect;
  }
}


=head1 NAME

    DBIx::Ease - less-code DBI interactions

=head1 SYNOPSIS

    use DBIx::Ease;

    my $csv_cons = new DBIx::Ease('CSV');

    $csv_cons->exec(
       "databasename",      # using CSV this is the path
       "DELETE from somename where i=1");

    my @results = $csv_cons->exec("databasename","SELECT ..");

    $csv_cons->disconnect_all;

=head1 DESCRIPTION

    DBIx::Ease is intended to allow less-code DBI interactions. Version 0.04
    uses DBD::CSV. exec() takes currently two arguments, the path 'f_dir'
    and a SQL statement. exec() handles connects or reuse of connections,
    prepare, execute and returns an array of all selected rows for SELECTs.

    DBIx::Ease is currently in pre-alpha; rather a prototype.
    
=head1 INSTALLATION

    Standard build/installation supported by ExtUtils::MakeMaker(3)...
    perl Makefile.PL
    make
    make install

=head1 AUTHOR

    Alexander Pourmirzayouf <commerce_cgi@yahoo.com>

=cut

