#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  exTk.pl
#
#        USAGE:  ./exTk.pl  
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
#      CREATED:  04/07/2019 17:09:06
#     REVISION:  ---
#===============================================================================
use Modern::Perl '2018';

    use strict;
    use Tk;
    #  Création du TopLevel
    my $top = MainWindow->new(-title => 'fig2');

    #  Création du widget Button
    $top -> Button(-background => 'yellow', -text => 'bouton') -> pack;

    #  Création d'un cadre (Widget Frame)
    my $frame1 = $top->Frame()->pack(-fill => 'x');

    #  Création de deux boutons Radio dans le Cadre
    #  Création de la variable commune aux Boutons Radio
    my $var_rb;
    #  Création du premier bouton Radio
    my $rbutton1 = $frame1 -> Radiobutton(
                           -text => 'bouton',
                           -value => 'bouton',
                           -variable => \$var_rb
        ) -> pack(-side => 'left');
    # positionnement de l'état du bouton rbutton1 en mode sélectionné

    $rbutton1->select;
    #  Création du second bouton Radio
    my $rbutton2 = $frame1 -> Radiobutton(
                           -state => 'active',
                           -text => 'radio',
                           -value => 'radio',
                           -variable => \$var_rb
        ) -> pack(-side => 'left');
    # positionnement de l'état du bouton rbutton1 en mode désélectionné

    $rbutton2->deselect;

    # Création d'un bouton à cocher
    $top -> Checkbutton(
                    -background => 'green',
                    -text => 'Checkbutton'
            ) -> pack;

    # Création d'une liste
    my $lb = $top -> Listbox() -> pack;
    $lb->insert('end', "itemFin");
    $lb->insert(2, "item1", "item2");
    $lb->insert(0, "itemA", "itemB");
    $lb->insert(4, "item3", "item4");

    # Création d'une barre de défilement
    $top -> Scrollbar() -> pack;

    # Création de deux lignes de "dialogue"
    $top -> Entry(-text => 'Login') -> pack;
    $top -> Entry(-text => 'passwd', -show => '*') -> pack;

    # Sous-Programme de création d'un bouton image


    icon_mini();

    # et enfin l'incontournable :

    MainLoop;

    # Ce sous-programme est la reproduction d'un
    # exemple sur le Web dû à Peter Prymmer
    # Cornell University, Ithaca NY

    sub icon_mini {

        # $Tk::library est le chemin ou se trouve ../lib/Tk/demos
        my $window = $top;

        # les bitmaps flagup et flagdown sont en standard
        # dans la distribution Tk

        $window->Bitmap('flagup',
              -file => "$Tk::library/demos/images/flagup",
              -maskfile => "$Tk::library/demos/images/flagup",
        );
        $window->Bitmap('flagdown',
              -file => "$Tk::library/demos/images/flagdown",
              -maskfile => "$Tk::library/demos/images/flagdown",
        );

        my $w_frame_b1 = $window->Checkbutton(
              -image            => 'flagdown',
              -selectimage      => 'flagup',
              -indicatoron      => 0,
        );
        $w_frame_b1->pack();

    } # end icon

