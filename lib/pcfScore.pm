#
#===============================================================================
#
#         FILE:  pcfScore.pm
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
package pcfScore {
use Modern::Perl '2018';
use Moose;
use FindBin;
use lib "$FindBin::Bin/./";
use experimental qw( switch) ; 

#Attributes
has 'user' , is => 'ro', isa => 'Str';
has 'file', is=> 'ro', isa => 'Str', default => './file/score';
has 'score', 	traits => ['Hash'],
				is=> 'rw',
				isa => 'HashRef', 
				default   => sub { {} },
      			handles   => {
          			set_option     => 'set',
          			get_option     => 'get',
          			has_no_options => 'is_empty',
          			num_options    => 'count',
          			delete_option  => 'delete',
          			option_pairs   => 'kv',
      			};
has 'winners', 	traits => ['Hash'],
				is=> 'rw',
				isa => 'HashRef', 
				default   => sub { {} },
      			handles   => {
          			winners_set     => 'set',
          			winners_get     => 'get',
          			winners_no_options => 'is_empty',
          			winners_count    => 'count',
          			winners_delete  => 'delete',
          			winners_pairs   => 'kv',
							};

sub read {
	my $self = shift;
	my $filename = $self->file;
	my %tab;
	open(IN,"< $filename")|| die "Impossible to open the file $filename";
	while (my $text=<IN>) {
		chomp($text);
         my @list = split(/,/,$text);
		$self->set_option("$list[0]","$list[1],$list[2]") ;	
	 }
	 close IN;
}


sub write {
	my $self = shift;
	my $filename = $self->file; 
	my $hashref = $self->score ;
	open(OUT,"> $filename")|| die "Impossible to open the file $filename";
	while ( (my $clef, my $valeur) = each %$hashref ) {
    	print OUT "$clef,$valeur\n";
	 }
	 close OUT;
}

sub getUserScore {
	my $self = shift;
	my $user = $self->user ;
	my $text =  $self->get_option("$user");
	if (!defined( $text ) ){
		$text = "0,0";
		$self->set_option("$user","$text");
	}
	my @score = split(/,/,$text );

	return @score ;
}

sub setUserScore {
	my $self = shift;
	my $result = shift;
	my $user = $self->user ;
	my @score = $self->getUserScore( );
	if ($result eq 'V'){
		$score[0]++;
	}else{
		$score[1]++;
	}
	$self->set_option("$user","$score[0],$score[1]");
	$self->write( );
	return @score;
}

sub winPerCent {
	my $self = shift;
	my $hashref = $self->score ;
	my @winners ;
	my @apercent ;
	while ( (my $clef, my $valeur) = each %$hashref ) {
		my @score = split(/,/,$valeur );
		my $percent = int(( $score[0] / ($score[0] + $score[1])) * 100);
		push(@apercent, $percent);
		my @sorted =sort { $a <=> $b } @apercent ;
		@apercent = reverse( @sorted );
		
		$self->winners_set("$clef","$percent");	
	 	my $nbr = @winners ;
		if ( $nbr == 0 ){
				$winners[0] = $clef;
			} else {
			while( ( my $index, my $value) = each @apercent ){
					if ( $percent == $value ){
						if ( $index < $nbr) {
							my @removed = splice @winners, $index, 0, $clef;
						} else {
							push @winners , $clef ;
						}
						last;
					}
				}	

			}
		}
	my @removed = splice @winners, 10;	
	return @winners;
}
}
1;

