package DBIx::Ease;
# Copyright (c) 2002 Alexander Pourmirzayouf. All rights reserved.

use strict;
use DBI;
use vars qw($VERSION);
$VERSION = "0.02";

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

1;