package DBIx::Ease;
# Copyright (c) 2002 Alexander Pourmirzayouf. All rights reserved.

use strict;
use DBI;
use vars qw($VERSION);
$VERSION = "0.07";

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
    }else{
      my $user = shift;
      my $pass = shift;
      my $dsn = $self->{'drv'};
      $dsn =~ s/<databasename>/$name/g;
      $self->{'cons'}{$name} = DBI->connect($dsn, $user, $pass);
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

    DBIx::Ease - less-code DBI interactions for all drivers

=head1 SYNOPSIS

    use DBIx::Ease;

    my $cons = new DBIx::Ease('DBI:mysql:<databasename>');

    $cons->exec(
       "databasename",
       "DELETE FROM somename WHERE i=1", "user", "password");

    my @results = $cons->exec("databasename","SELECT ..");

    $cons->disconnect_all;

=head1 DESCRIPTION

    DBIx::Ease is intended to allow less-code DBI interactions. Version 0.07
    works with any driver, but still supports the use as in versions prior 
    0.06.

    Upon creation of a new DBIx::Ease object you should pass the portion
    of the DSN (Data Source Name) common to all connections the object is
    supposed to store. Replace the variable portions with '<databasename>'.
    Whenever you wish to make only one connection you may enter the complete
    DSN, also when you want to make connections with the same source but as 
    different users, then call exec() with different names of your choice as  
    initial argument.
     
    exec() takes the portion of the DSN which has been kept variable as its
    first argument or a connection name of your choice if a complete DSN was 
    entered when creating the object. exec() automatically reuses established 
    connections.

    Any SQL statement is the second argument; exec() returns an array with all 
    selected values/rows for SELECTs.
    
    User name and password are optional third and fourth arguments to exec() to
    use where new connections are established and stored in the object.

    Calling disconnect_all() will close all connections with the calling object.

=head1 INSTALLATION

    perl Makefile.PL
    make
    make test
    make install

=head1 AUTHOR

    Alexander Pourmirzayouf <commerce_cgi@yahoo.com>

=cut

