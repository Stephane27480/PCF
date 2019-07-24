#
#===============================================================================
#
#         FILE:  pcfGame.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Stéphane Bailleul (SBL), sbl27480@gmail.com
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  03/07/2019 18:12:43
#     REVISION:  ---
#===============================================================================
package pcfGame {
use Modern::Perl '2018';
use Moose;
use FindBin;
use lib "$FindBin::Bin/./";
use experimental qw( switch) ; 

#Attributes
has 'user' , is => 'rw', isa => 'Str', writer => '_set_user';
has 'host' , is => 'ro', isa=>'Str';
has 'userScore', is=> 'rw', default => 0, writer => '_set_uscore';
has 'compuScore', is=> 'rw', default => 0, writer => '_set_cscore';
has 'partyScore', is=> 'rw', default=> 5;

sub play {
	my $self = shift;
	my $userPlay = shift;
	my @options = ( "pierre", "feuille", "ciseaux" );
	my $method = $options [ rand @options ];
	my @values ;
	my $rpartyScore = $self->partyScore ;
	if (my $f = $self->can($method)) {
		@values =  $self->$f($userPlay);
	}

	my $ruserScore = $self->userScore ;
	my $rcompuScore = $self->compuScore;
	if ( ($ruserScore == $rpartyScore ) || ($rcompuScore == $rpartyScore)){
		push @values, 1;
	} else {
		push @values, 0;
	}
	return @values;
}


sub pierre {
	my $self = shift; 
	my $ruserScore = $self->userScore ;
	my $rcompuScore = $self->compuScore;
	my $gameText = "J'ai choisi pierre.\n ";
	my $gagnant = 'none';
	for (shift) {
		when (/feuille/) { $gameText .= 'Tu gagnes!';
						$self->_set_uscore( $ruserScore += 1 );
						$gagnant = $self->user ;
					};
						
		when (/pierre/) { $gameText .= 'Egalite !'}
		when (/ciseaux/) {$gameText .=  'Je gagne !!';
						$self->_set_cscore( $rcompuScore += 1 );
						 $gagnant = $self->host;
					};
	}

	return my  @values = ( $gameText , $gagnant );				
}


sub feuille {
	my $self = shift; 
	my $ruserScore = $self->userScore ;
	my $rcompuScore = $self->compuScore;
	my $gameText = "J'ai choisi feuille.\n ";
	my $gagnant = 'none';
	for (shift) {
		when (/feuille/) { $gameText .= 'Egalite !' };
		when (/pierre/) { 	$gagnant = $self->host ; 
							$gameText .=  "Je suis le plus fort !!"; 
							$self->_set_cscore( $rcompuScore += 1 );};
		when (/ciseaux/) { 	$gameText .= 'Tu gagnes!';
							$gagnant = $self->user ;
							$self->_set_uscore( $ruserScore += 1 );};
	}
	return my  @values = ( $gameText , $gagnant );				
}


sub ciseaux {
	my $self = shift; 
	my $ruserScore = $self->userScore ;
	my $rcompuScore = $self->compuScore;
	my $gameText = "J'ai choisi ciseaux. ";
	my $gagnant = 'none';
	for (shift) {
		when (/feuille/) { 	$gameText .=  'Je gagne !!';
							$self->_set_cscore( $rcompuScore += 1 ); 
							$gagnant = $self->host ; 
					};
		when (/pierre/) { 	$gameText .=  "Je perds...";
							$self->_set_uscore( $ruserScore += 1 );
							$gagnant = $self->user ; 
					};
		when (/ciseaux/) {	$gameText .= 'Egalite !' };
	}

	return my  @values = ( $gameText , $gagnant );				
}
sub setUser{
	my $self = shift;
	my $user = shift;
	$self->_set_user( $user );
}
}
1;
