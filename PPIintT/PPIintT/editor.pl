#! /usr/bin/env perl

use strict; use warnings;
use utf8;
use lib "../lib";
use open ":std", ":encoding(UTF-8)";
use Term::Graille  qw/colour paint printAt cursorAt clearScreen border blockBlit block2braille pixelAt/;
use Term::Graille::Interact ;
use Term::Graille::Menu qw/deathSentence wrapText/;
use Term::Graille::Textarea;
use Term::Graille::Selector;
use Time::HiRes qw/sleep/;
use Data::Dumper;

my $canvas;

my $io=Term::Graille::Interact->new();
$io->{debugCursor}=[22,45];
my $width  = $io->{terminalWidth}*1.8,
my $height = $io->{terminalHeight}*2.3,
my $mode="Editor";

sub makeCanvas{
	$canvas = Term::Graille->new(
		width=>$width,
		height=>$height,
		top=>4,
		left=>6,
		borderStyle => "double",
		title=>"Logo $mode",
	  );
}

my @colours=qw/red blue green yellow cyan magenta white/;

# setup keyboard short cuts

my $menu=new Term::Graille::Menu(
          menu=>[["File","New","Load","Save","Quit"],
                 ["Edit",["Select","All","Start","End"],["Selection","Copy","Cut","Paste"],"Search","Replace"],
                 ["View","Editor","Viewer"],
                 ["test","Death","Message","Input","Selector"],
                 "About"],
          redraw=>\&refreshScreen,
          callback=>\&menuActions,
          );

my $textarea=new Term::Graille::Textarea();

makeCanvas();
refreshScreen();

my %actions = ( New  => sub{},
                Load => sub{ load()},
                Save => sub{ save() },
                Editor=>sub{mode("Editor")},
                Viewer=>sub{mode("Viewer")},
              );
          
$io->addObject(object => $menu,trigger=>"m");
$io->addObject(object => $textarea,trigger=>"e");

$io->run();

sub mode{
	$mode=shift;
	$canvas->{title}="Logo $mode";
	if ($mode eq "Editor"){
		$textarea->draw();
	}
	else{
		$canvas->draw();
	}
}

sub refreshScreen{
	clearScreen() unless (shift);
	$canvas->draw();
	$textarea->draw();
}

sub menuActions{
	my ($action,$gV)=@_;
	if (exists $actions{$action}){
		$actions{$action}->($gV)
	}
	else{
		printAt(2,60,$action)
	}
};

sub load{
	my ($dir,$filters)=@_;
	$dir//=".";
	$filters//="pl";
	opendir(my $DIR, $dir) || die "Can't open directory $dir: $!";
	my @files = sort(grep {(/$filters/) && -f "$dir/$_" } readdir($DIR));
	closedir $DIR;
	my $selector=new Term::Graille::Selector(
          redraw=>\&refreshScreen,
          callback=>\&loadFile,
          options=>[@files],
          transient=>1,
          );
    my $selId=$io->addObject(object => $selector);
    $io->start($selId);
	
}		

sub loadFile{
	my $file=shift;
	$io->close();
	printAt(2,60,$file);
}
