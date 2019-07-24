 use strict;
 use FindBin;
 use lib "$FindBin::Bin/../lib";
 use warnings;
 use pcfGame ;
use Test::More tests => 3;
use Moose;

 # Test instanciation 
my $user = "Stéphane";

my $class = pcfGame->new( user => $user,
						partyScore => 3
						);
my $rtext = $class->play("pierre");
ok  $rtext,  "1- text: $rtext";
my $ruserScore =  $class->userScore; 
my $rcompuScore =  $class->compuScore; 
ok $rcompuScore,  "2- CompuScore= $rcompuScore";
ok $ruserScore,  "3- userScore= $ruserScore";

done_testing();


