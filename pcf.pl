#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  pcf.pl
#
#        USAGE:  ./pcf.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Stéphane Bailleul (SBL), sbl27480@gmail.com
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  05/07/2019 16:35:55
#     REVISION:  ---
#===============================================================================
use Modern::Perl '2018';
use Moose ;
use FindBin;
use lib "$FindBin::Bin/./lib";
use Tk ;
use Tk::widgets qw/JPEG PNG/;
use pcfGame;
use pcfScore;
use Sys::Hostname;
use experimental qw( switch);
#use Tk::ToplevelIcon;
#Main
my $host = hostname;
my $name = undef ;
my $gamePoints = undef;
my $class ;
my $uscore;
my $cscore;
my @values ;
my $infos;
my $score;
#tkinit;
my $mw= MainWindow->new;
$mw->title("Pierre Feuille Ciseaux");
$mw->configure(-background => 'white' );
my $icon = $mw->Photo(	-file => "$Tk::library/Tk.xpm",
						-format => "xpm",
					);
$mw->Icon (-image => $icon);
$mw->iconmask('Tk');
&deactivate_mw ;
	if (! defined $name ){
		&introduction ;
	}
	if ((defined $name) && (! defined $gamePoints)) {
		&nbrParties ;
	}

	if ((defined $name) && (defined $gamePoints)){
			&getClass;
	}		
MainLoop;


sub introduction {
if (! Exists(our $tl1)) {
	$tl1 = $mw->Toplevel( );
	$tl1->title("Introduction");
	$tl1->configure(-background => 'white' );
	$tl1->withdraw( );
	$tl1->Popup ;
	$tl1->focus;
	$tl1->Label(-text => "Je suis $host et toi qui es tu ?",
			-anchor => 'center',
			-background => 'white',
			-foreground => 'blue'
		)->pack;
	my $entry = $tl1->Entry(-textvariable => \$name,
							-background => 'white',
							-takefocus => 1	)->pack;
	$entry->focusForce ;
	$tl1->Button(	-text => "OK",
					-foreground => 'blue',
					-background => 'white',
					-activebackground => 'blue',
					-activeforeground => 'white',
					-command => sub {
			$tl1->withdraw ;
			&nbrParties ;
		})->pack();
	} else {
		$tl1->deiconify( );
		$tl1->raise( );
	}
}

sub nbrParties {
if (! Exists(my $tl2)) {
	$gamePoints = 5;
	$tl2 = $mw->Toplevel( );
	$tl2->configure(-background => 'white' );
	$tl2->title("Combien de Points ?");
	$tl2->withdraw( );
	$tl2->Popup ;
	$tl2->Label(	-text => "Combien de points faut il atteindre pour gagner ?",
					-anchor => 'center',
					-background => 'white',
					-foreground => 'blue'
				)->pack;
	my $entry = $tl2->Entry(-textvariable => \$gamePoints,
							-takefocus => 1,
							-background => 'white')->pack;
	$entry->focusForce;					
	$tl2->Button(	-text => "OK",
					-foreground => 'blue',
					-background => 'white',
					-activebackground => 'blue',
					-activeforeground => 'white',
					-command => sub {
			$tl2->withdraw;
			&getClass ;
				if ( defined($values[2]) && $values[2] == 1){
					$values[2] = 3 ;
					&score;
					&activate_mw;
				}else{	
					&gameScreen ;
				}	
		})->pack( );

				
				} else {
		$tl2->deiconify( );
		$tl2->raise( );
	}
}

sub gameScreen {
	my $imgPierre = $mw->Photo( -file => "./img/pierre.jpeg");
	my $imgCiseaux = $mw->Photo( -file => "./img/ciseau.jpeg" );
	my $imgFeuille = $mw->Photo( -file => "./img/feuille.jpeg");
	$uscore = $class->userScore;
	$cscore = $class->compuScore;
	$infos = $mw->Label(	-text => "Points a atteindre : $gamePoints\t$name : \t$uscore \t\t $host : \t$cscore\n",
							-anchor => 'center',
							-background => 'white')->pack;

$mw->Button(-text => 'Pierre',
			-underline => 0,
			-relief => 'flat',
			-command => sub { 	@values = $class->play('pierre'); 
								&score;
							},
							-image => $imgPierre,
		)-> pack( -side => 'left');

$mw->Button(-text => 'Feuille',
			-underline => 0,
			-relief => 'flat',
			-command => sub { 	@values = $class->play('feuille');
								&score;
							},
				-image => $imgFeuille,
		)-> pack( -side => 'left');
$mw->Button(-text => 'flat',
			-underline => 0,
			-relief => 'flat',
			-command => sub { 	@values = $class->play('ciseaux');
								&score;
							},
				-image => $imgCiseaux,
		)-> pack( -side => 'left');
&activate_mw ;

	}
sub activate_mw {
	$mw->withdraw( );
	$mw->Popup ;
	$mw->deiconify();
	$mw->raise();
	$mw->update();
}

sub deactivate_mw {
	$mw->withdraw();
}

sub score {
	$uscore = $class->userScore;
	$cscore = $class->compuScore;
	$infos->configure(	-text=> "Points a atteindre : $gamePoints \t$name : \t$uscore \t\t $host : \t$cscore\n $values[0]",
						-background => 'white', 
						-foreground => 'blue' 
					);
	$mw->update();
	if ($values[2] == 1) {
     # End of the current game
	sleep(1);
	&deactivate_mw;
	&endGame ;
	}
}
sub getClass {
		  $class = pcfGame->new( 
			  		user => $name,
					host => $host,
					partyScore => $gamePoints ,
					userScore => 0,
					compuScore => 0
						);
		$score = pcfScore->new(
					user => $name
				);
		$score->read( );		
}

sub endGame {

if (! Exists(my $tl3)) {
	my $gagnant = $values[1];
	if ( $gagnant eq $name ){
		$score->setUserScore('V');
	}else{
		$score->setUserScore('G');
	}
	$tl3 = $mw->Toplevel( );
	$tl3->withdraw( );
	$tl3->configure(-background => 'white' );
	$tl3->Popup ;
	$tl3->title("Fin de Partie");
	$tl3->Label(	-text => "$gagnant gagne !\n\n",
					-anchor => 'center',
					-background => 'white',
					-foreground => 'blue',
				)->pack;
	$tl3->Button(	-text => "Une autre partie",
					-foreground => 'white',
					-activebackground => 'white',
					-activeforeground => 'green',
					-background => 'green',
					-takefocus => 1, 	
					-command => sub {
						$tl3->withdraw;
						&nbrParties ;
				})->pack( -side => 'left');
	
	$tl3->Button(	-text => "Meilleurs Joueurs",
					-foreground => 'white',
					-activebackground => 'white',
					-activeforeground => 'blue',
					-background => 'blue',
					-takefocus => 1, 	
					-command => sub {
						$tl3->withdraw;
						&record ;
				})->pack(-side => 'left' );
	$tl3->Button(	-text => "Stop",
					-foreground => 'white',
					-activebackground => 'white',
					-activeforeground => 'red',
					-background => 'red',
					-relief => 'flat',
					-command => sub {
						$tl3->withdraw;
						exit ;
				})->pack(-side => 'left' );
	} else {
		$tl3->deiconify( );
		$tl3->raise( );
	}
}	


sub record{

if (! Exists(my $tl4)) {
	$tl4 = $mw->Toplevel( );
	$tl4->withdraw( );
	$tl4->configure(-background => 'white' );
	$tl4->Popup ;
	$tl4->title("Meilleurs Joueurs");
	my @winner = $score->winPerCent( );
	my $n;
	my $t = $tl4->Text(		-background => 'white',
								)->pack;
	$t->tagConfigure('green', -foreground => "green");
	$t->tagConfigure('blue', -foreground => "blue");
	$t->tagConfigure('red', -foreground => "red");
	$t->insert( 'end', "Place\t\tNom\t\t% Victoire\n" );
	foreach my $winner (@winner){
		my $percent = $score->winners_get( $winner );
		my $color ;
		$n++ ;
		my $padding = " ";
		my $length = 20;
		my $pad_length = $length - length $winner;
    	$pad_length = 0 if $pad_length < 0;
    	$padding x= $pad_length;
    	$winner.$padding;

		if ($percent > 50){
			$color = 'green';
		} elsif ($percent < 26)	{
			$color = 'red';
		} else {
			$color = 'blue';
		}
		$t->insert( 'end', "$n\t\t$winner\t\t$percent\n", $color);

	}

	$tl4->Button(	-text => "Une autre partie",
					-foreground => 'white',
					-activebackground => 'white',
					-activeforeground => 'green',
					-background => 'green',
					-takefocus => 1, 	
					-command => sub {
						$tl4->withdraw;
						&nbrParties ;
				})->pack(-side => 'left' );
	$tl4->Button(	-text => "Stop",
					-foreground => 'white',
					-activebackground => 'white',
					-activeforeground => 'red',
					-background => 'red',
					-relief => 'flat',
					-command => sub {
						$tl4->withdraw;
						exit ;
				})->pack(-side => 'right' );
	} else {
		$tl4->deiconify( );
		$tl4->raise( );
	}
}	
