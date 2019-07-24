#
#===============================================================================
#
#         FILE:  pcfScreen.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Stéphane Bailleul (SBL), sbl27480@gmail.com
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  04/07/2019 16:28:28
#     REVISION:  ---
#===============================================================================

use Modern::Perl '2018';
use Test::More tests => 2;                      # last test to print
use FindBin;
 use lib "$FindBin::Bin/../lib";
 use warnings;
use pcfScreen;
use pcfGame;
use Moose;

my $class = pcfScreen->new( host => "Ordi" );
$class->introduction;
my $rhost = $class->host;
is $rhost, 'Ordi', "1- Nom Host = $rhost";
my $ruserName = $class->userName;
 ok $ruserName , "2- User name $ruserName ";
 
 # Test nombre de parties
my $points = $class->nbrParties;
ok $points , "3- Nombre de points $points";

# test integration
my  $game = pcfGame->new( user => $ruserName,
						partyScore => 3);
my $response = $class->gameScreen( \$game );
my $ruserScore =  $class->userScore; 
my $rcompuScore =  $class->compuScore; 
my $scoreHigh ;
if ($ruserScore > $rcompuScore){
	$scoreHigh = $ruserScore}
else { $scoreHigh = $rcompuScore }
ok $scoreHigh, "4- le plus gros score $scoreHigh";


done_testing();


