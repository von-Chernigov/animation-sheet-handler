#!/usr/bin/perl

use strict;
use warnings;
use Image::Magick;

print "hello I am your computer \n";

my $image;

### setup ###
# image main settings
my $iwidth=2480;
my $iheight=3508;
my $ali_linewidth=8;
my $ali_width=40;
# frames settings 
my $frames_distance=50;
my $frames_per_row=3;
my $rows_per_page=2;

$image=Image::Magick->new;

# Create canvas - A4 size at 300dpi
$image->Set(size=>$iwidth."x".$iheight);
$image->Read('canvas:white');

# Drawing frames frames (sic)

#draw_frame(60,60,590,590,10);
my $frame_width=($iwidth-($ali_width*2)-($ali_linewidth*2)-(($frames_per_row+1)*$frames_distance))/($frames_per_row);
print "frame width $frame_width \n";
my $frame_height=$frame_width; # nutne upravit
my $f_corheight=$ali_width+$ali_linewidth+$frames_distance; #nutne upravit
for (my $r=1; $r le $rows_per_page; $r++) {
	my $f_corwidth=$ali_width+$ali_linewidth+$frames_distance;
	for (my $rf=1; $rf le $frames_per_row; $rf++) {
		print "row $r row frame $rf \n";
		draw_frame($f_corwidth,$f_corheight,$frame_width,$frame_height,10);
		$f_corwidth+=$frames_distance+$frame_width;
	}
	$f_corheight+=$frames_distance+$frame_height;
}




# Drawing aligment lines
$image->Draw(primitive=>'line', points=>"$ali_width,$ali_width $ali_width,".($iheight-$ali_width), strokewidth=>$ali_width, gravity=>'East'); #left
$image->Draw(primitive=>'line', points=>"$ali_width,$ali_width ".($iwidth-$ali_width).",$ali_width", strokewidth=>$ali_width, gravity=>'South'); #upper
$image->Draw(primitive=>'line', points=>($iwidth-$ali_width).",$ali_width ".($iwidth-$ali_width).",".($iheight-$ali_width), strokewidth=>$ali_width, gravity=>'West'); #right
$image->Draw(primitive=>'line', points=>"$ali_width,".($iheight-$ali_width)." ".($iwidth-$ali_width).",".($iheight-$ali_width), strokewidth=>$ali_width, gravity=>'North'); #bottom

$image->Write('output.png');


############################
#        Functions         #
############################

# Draw one frame draw_frame(leftuppercorner_w,leftuppercorner_h,hor_size,ver_size,borderwidth)
sub draw_frame {
	my ($luc_w,$luc_h,$hor_size,$ver_size,$border) = @_;
	$image->Draw(primitive=>'rectangle', points=>"$luc_w,$luc_h ".($luc_w+$hor_size).",".($luc_h+$ver_size), fill=>'black');
	$image->Draw(primitive=>'rectangle', points=>($luc_w+$border).",".($luc_h+$border)." ".($luc_w+$hor_size-$border).",".($luc_h+$ver_size-$border), fill=>'pink');
}
