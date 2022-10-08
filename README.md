# Perl-Interminable (or PPIintT)
Console Based IDE for Perl And Logo written in Pure(ish) Perl

Perl IDEs written in Perl include Pardre and perhaps others.  Many other IDEs exist capababler of suipporting Perl code, some with useful GUI interfaces, some as plugins to console IDEs like vim and EMACs.  [Term::Graille](https://github.com/saiftynet/Term-Graille) was written with the goal of allowing Terminal based pseudo graphical applications.  Key to interactive applications is the use of familiar concepts of interattions, e.g. hiearchical menus and dialog boxes, text editting capabil;ity as well as graphical representaions.  These are not easy on the terminal.

Perl users have access to the wonderful and comprehensive [Tickit](https://metacpan.org/dist/Tickit) libraries by [Paul Evans](https://metacpan.org/author/PEVANS). This is sophisticated and powerful and would be the ideal starting for any sensible and competent programmer keen of develiping a console based editor for Perl.  Equally sensible ones might ALSO opt for [Curses](https://metacpan.org/pod/Curses).  But others, not so sensible coders might choose to help brewing a PPiinTt (short for Pure Perl Ide In The Terminal). If you think you are seeing double, this is the desired effect of consuming such beerbrained ideas.

## Goals

* A(nother) console based code/text editor.
* Written in Pure Perl, with very few dependencies. (ANSI compatible terminal based so no other graphical libraries)
* Using familiar interface concepts such as hierarchical menus, text editing panels, grphical drawing surfaces, file selectors and dialog boxes.
* Along with the infrastructure to create other interactive applications
* With the primary objective being Simplicity.
* The secret final goal is to be the development for the eventually to be released PerlayStation Games Console.  A games console/terminal that runs on Terminals, written in Perl.  Games could be graphical or text based, mostly pure Perl.  Graille offers pseudo pixel graphics, which can be easily mixed with text.  

## Methods  

* The development of a new interaction platform for the Terminal
* Key capture using Term::ReadKey
* Console drawing using Term::Graille
* Develop Term::Graille::Interact,  Term::Graille::Menu,  Term::Graille::Selector,  Term::Graille::Dialog
* Develop a text editor not dissimilar in concept to [ped](https://github.com/daansystems/ped) by [daansystems](https://www.daansystems.com/)
* use this to create a Logo Editor
* Use concepts learnt to create a Perl IDE for the console
* Use this IDE to create other Console applications.
 
