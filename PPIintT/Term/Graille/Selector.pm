package  Term::Graille::Selector;

use strict;use warnings;
use Term::Graille qw/colour printAt clearScreen border cursorAt/;
use utf8;

=head3 C<my $selector=Term::Graille::Selector-E<gt>new(%params)>

Creates a new $chooser; params are
C<options> the possible options that may be selected  
C<redraw> This is a function to redraws the application screen.
The chooser may overwrite parts of the application screen, and this 
function needs to be provided to restore the screen.
C<callback> The chooser does not call any functions, instead returns the
selected item(s).  It is upto the main application to use this data (the
callback function supplied)
C<pos> Optional. The default position is [2,2], but setting this parameter allows 
the chooser to be placed elsewhere
C<highlightColour> Optional. The selected item is highlighted default "black on_white"
C<normalColour> Optional. The normal colour of menu items "white on_black"


=cut


sub new{
    my ($class,%params) = @_;  
    my $self={};
    bless $self,$class;
    $self->{options}=$params{options}//[];
    $self->{redraw}=$params{redraw} if (exists $params{redraw});        # function to redraw application
    $self->{callback}=$params{callback} if (exists $params{callback});  # function to call after menu item selected 
	$self->{selected}=$params{selected}//  $self->{options}->[0];
	$self->{pointer}=0;
	$self->{start}=$params{start}//0;
	$self->{ioMode}="chooser";
	$self->{title}=$params{title}//"Chooser";
	$self->{normalColour}=$params{titleColour}//"yellow";
	$self->{multi}=$params{multi}//0;
	$self->{pos}=$params{pos}//[2,2];
	$self->{geometry}=$params{geometry}//[13,20];
	$self->{highlightColour}=$params{highlightColour}//"black on_white";
	$self->{normalColour}=$params{normalColour}//"white on_black";
	$self->{keyAction}={
		"[A"   =>sub{$self->prevItem()},
		"[B"   =>sub{$self->nextItem()},
		"[C"   =>sub{$self->selectItem()},
		"enter"=>sub{$self->selectItem()},
		"esc"  =>sub{$self->{close}->()},
	};
	return $self;
}

sub draw{
	my ($self)=@_;
	border($self->{pos}->[0],$self->{pos}->[1],
	       $self->{pos}->[0]+$self->{geometry}->[0],$self->{pos}->[1]+$self->{geometry}->[1],
	       "thick",$self->{focus}?$self->{focusColour}:$self->{blurColour},
	       $self->{title},$self->{titleColour});
	$self->{start}++ while ($self->{pointer}>$self->{start}+$self->{geometry}->[0]-1);
	$self->{start}-- while ($self->{pointer}<$self->{start});
	foreach ($self->{start}..$self->{start}+$self->{geometry}->[0]-1){ 
		if ($_<@{$self->{options}}){		
			my $colour=colour(isSelected($self,$self->{options}->[$_])?"black on_white":"white");
			$colour.=colour(($_==$self->{pointer})?"underline":"");
			printAt($self->{pos}->[0]+$_+1-$self->{start},$self->{pos}->[1]+1,
			        $colour.$self->{options}->[$_].colour("reset"));
		}
	}
}

sub setSelected{
	my ($self,$item)=@_;
	for my $o (0..$#{$self->{options}}){
		if ($self->{options}->[$o] eq $item){
			if ($self->{multi}==0){
				$self->{selected}=[$o]
			}
			else{
				# for multiselect
			}
		}
	}
}

sub isSelected{
	my ($self,$item)=@_;
	my $sel=ref($self->{selected})?$self->{selected}:[$self->{selected}];
	for my $s (@{$sel}){
		return 1 if ($s eq $item)
	}
	return 0	
}

sub nextItem{
	my ($self)=@_;
	$self->{pointer}++ unless ($self->{pointer} >=$#{$self->{options}});
	$self->draw();
	return $self->{options}->[$self->{pointer}];
}

sub prevItem{
	my ($self)=@_;
	$self->{pointer}-- unless ($self->{pointer} <=0);
	$self->draw();
	return $self->{options}->[$self->{pointer}];
}

sub selectItem{
	my ($self,@otherStuff)=@_;
	if ($self->{multi}==0){
		$self->{selected}=[$self->{options}->[$self->{pointer}]];
		$self->{redraw}->();
		$self->{callback}->($self->{options}->[$self->{pointer}],@otherStuff) if $self->{callback};
		return $self->{options}->[$self->{pointer}];
	}
	else{
		#for multiselect
	}
}



sub close{  # what needs to be done before Interact de-activates widget
	my ($self)=@_;
	$self->{redraw}->();
}

1;
