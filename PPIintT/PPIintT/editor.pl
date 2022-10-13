#! /usr/bin/env perl

use strict; use warnings;
use utf8;
use lib "../lib";
use open ":std", ":encoding(UTF-8)";
use Term::Graille  qw/colour paint printAt cursorAt clearScreen border blockBlit block2braille pixelAt/;
use Term::Graille::Interact ;
use Term::Graille::Menu;
use Term::Graille::Textarea;
use Term::Graille::Selector;
use Term::Graille::Dialog;
use Time::HiRes qw/sleep/;
use Data::Dumper;

my $io=Term::Graille::Interact->new();
$io->{debugCursor}=[22,45];

my @colours=qw/red blue green yellow cyan magenta white/;

# setup keyboard short cuts

my $menu=new Term::Graille::Menu(  # no object offered so id will be o0 
          menu=>[["File","New","Load","Save","Quit"],
                 ["Edit",["Select","All","Start","End"],["Selection","Copy","Cut","Paste"],"Search","Replace"],
                 ["test","Death","Message","Input","Selector"],
                 "About"],
          redraw=>\&refreshScreen,
          dispatcher=>\&menuActions,
          );

# in this case the dispatcher directs to subroutines based on name of  
my %actions = ( New  => sub{},
                Load => sub{ load()},
                Save => sub{ save() },
                Editor=>sub{mode("Editor")},
                Viewer=>sub{mode("Viewer")},
                Message=>sub{message("Test Message")},
              );
              
sub menuActions{ # dispatcher for menu
	my ($action,$gV)=@_;
	if (exists $actions{$action}){
		$actions{$action}->($gV)
	}
	else{
		printAt(2,60,$action)
	}
};

my $textarea=new Term::Graille::Textarea();   # no object offered so id will be o1 

refreshScreen();
          
$io->addObject(object => $menu,trigger=>"m");
$io->addObject(object => $textarea,trigger=>"e");
$io->run();
$io->start("o1");

sub refreshScreen{
	clearScreen() unless (shift);
	$textarea->draw();
}

sub load{
	my ($dir,$filters)=@_;
	$dir//=".";
	$filters//="\.txt|\.logo\$";
	opendir(my $DIR, $dir) || die "Can't open directory $dir: $!";
	my @files = sort(grep {(/$filters/) && -f "$dir/$_" } readdir($DIR));
	closedir $DIR;
	my $selector=new Term::Graille::Selector(
          redraw=>\&refreshScreen,
          callback=>\&loadFile,
          options=>[@files],
          transient=>1,
          title=>"Load File",
          );
    my $selId=$io->addObject(object => $selector);
    $io->start($selId);
	
}		

sub loadFile{
	my $file=shift;
	open(my $fh, "<", "$file") or die("Can't open file $file:$! ");
	chomp(my @lines = <$fh>);
	close($fh);
	$textarea->{text}=[@lines];
	$io->close();
	printAt(2,60,"$file loaded");
	$io->start("o1");
}

sub save{
	my ($dir,$filters)=@_;
	$dir//=".";
	$filters//=".txt\.logo\$";
	opendir(my $DIR, $dir) || die "Can't open directory $dir: $!";
	my @files = sort(grep {(/$filters/) && -f "$dir/$_" } readdir($DIR));
	closedir $DIR;
	my $selector=new Term::Graille::Selector(
          redraw=>\&refreshScreen,
          callback=>\&saveFile,
          options=>[@files],
          transient=>1,
          title=>"Save File",
          );
    my $selId=$io->addObject(object => $selector);
    $io->start($selId);
	
}		

sub saveFile{
	my $file=shift;
	open(my $fh, ">", "$file") or die("Can't open file $file:$! ");
	print $fh join("\n",@{$textarea->{text}});
	close($fh);
	$io->close();
	printAt(2,60,"$file saved");
	$io->start("o1");
}

sub message{
	my ($message,$actionMatrix,$input)=@_;
	my $dialog=new Term::Graille::Dialog(
          redraw=>\&refreshScreen,
          callback=>\&+
          ,
          message=>$message,
          icon=>"info",
          title=>"Test Message",
          );
    $dialog->mode("input");
    my $dialogId=$io->addObject(object => $dialog);
    $io->start($dialogId);
}

sub messageReturn{
	my ($ret,@others)=@_;
	$ret||="nothing" ;
	$io->close();
	if ($ret){ printAt(2,50,"$ret @others returned") }
	
}
