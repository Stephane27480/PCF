 use strict;
 use FindBin;
 use lib "$FindBin::Bin/../lib";
 use warnings;
 use pcfScore ;
use Test::More tests => 5;
use Moose;

 # Test instanciation 
my $user = "Flora";
my $file = "./../tmp/scoret" ;
my $class = pcfScore->new(
				user => $user,
				file => $file,
			);
open(OUT,"> $file");
	print OUT 	"Stephane,5,10\n";
	print OUT 	"Roger,6,10\n";
	print OUT 	"Cecile,7,10\n";
	print OUT 	"Jean-Louis,8,10\n";
	print OUT 	"Florence,9,10\n";
	print OUT 	"Valerie,1,10\n";
	print OUT 	"Elise,2,10\n";
	print OUT 	"Regis,3,10\n";
	print OUT 	"Claudine,4,10\n";
	print OUT 	"Aurelien,4,10\n";
close OUT;	
$class->read();
my @score = $class->getUserScore( );
my $victory = $score[0];
my $defeat = $score[1];
is  $victory, 0, "1- victory: $victory";
is $defeat, 0, "2- Defeat: $defeat";
@score = $class->setUserScore('V');
is $score[0], $victory+1, "3- victoire : $score[0]";
@score = $class->setUserScore('G');
is $score[1], $defeat+1, "4- victoire : $score[1]";
#my $winnersRef = $class->winPerCent( );
#my @winners = @$winnersRef;
my @winners = $class->winPerCent( );
my $nbrWinners = @winners ;
is $nbrWinners, 10, "5- Nbre Gagnant = $nbrWinners - @winners\n";
done_testing();

unlink($file);
