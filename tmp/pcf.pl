#!/usr/bin/perl
use v5.26 ;
use experimental qw( switch );
#use encoding ':locale'; 
use Sys::Hostname;

my $host = hostname;
say "Mon nom est $host et toi, quel est ton nom ?";
chomp( my $name = <STDIN> );
say "Bonjour $name\n Jouons a Pierre Feuille Ciseaux\n";
sleep (2);
my $compu_score = 0;
my $name_score = 0;

my @options = ( \&pierre, \&feuille, \&ciseaux );
my $confused = "Je ne sais pas ce que tu veux faire !";

game( ) ;
sub game {
$compu_score = 0;
$name_score =0;
say " En combien de points veux tu jouer la partie ?";
chomp( my $count = <STDIN> );
	while ( ($compu_score < $count) & ($name_score < $count) ){
	my $text = "$host\t $compu_score\t $name\t$name_score\n";
$text .= "Pierre [p], Feuille [f], Ciseaux [c] ! Choisis en un: ";
	if ($^O=~ /Win/) {system("cls");}
	else{ system("clear");};
	say " $text";
	chomp( my $user = <STDIN> ) ;
	for ($user) {
		when (/\A[Pp]/) { $user = 'pierre'};
		when (/\A[Ff]/) { $user = 'feuille'};
		when (/\A[Cc]/) { $user = 'ciseaux'};
			}		
	my $computer_match = $options [ rand @options ];
	$computer_match->( lc( $user ) );
	}

	if ($^O=~ /Win/) {system("cls");}
	else{ system("clear");};
	result( );
}

sub result {

	say "-" x 40;
if ($compu_score > $name_score) {
	say "Je suis le plus fort !! $compu_score à $name_score"; }
	elsif ( $compu_score < $name_score ){
	say "$name tu m'as battu !!! $name_score à $compu_score"; }
	else { say "$name beau match égalité $compu_score partout";}
	
say "-" x 40;
say "Veux tu faire une autre partie Oui [o] ou Non [n] ?";
chomp (my $response = <STDIN>);
if ($response =~ /\A[Oo]/) { game( )};
}
sub pierre {
	say "J'ai choisi pierre. ";
	for (shift) {
		when (/feuille/) { say 'Tu gagnes!';
						$name_score++;};
		when (/pierre/) { say 'Egalité !' };
		when (/ciseaux/) {say 'Je gagne !!';
						$compu_score++;};
		default {say $confused };
	}
	sleep ( 2);
}


sub feuille {
	say "J'ai choisi feuille. ";
	for (shift) {
		when (/feuille/) {  say 'Egalité !' };
		when (/pierre/) { say "$host est le plus fort !!";
						$compu_score++;};
		when (/ciseaux/) { say 'Tu gagnes!';
						$name_score++;};
		default {say $confused };
	}
	sleep (2);
}


sub ciseaux {
	say "J'ai choisi ciseaux. ";
	for (shift) {
		when (/feuille/) {   say 'Je gagne !!';
						$compu_score++; };
		when (/pierre/) { say "Je perds...";
						$name_score++;	};
		when (/ciseaux/) {say 'Egalité !' };
		default {say $confused };
	}
	sleep (2);
}
