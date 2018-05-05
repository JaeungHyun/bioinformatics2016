#!/usr/bin/perl
use warnings;
use strict;

my $input=$ARGV[0];
my $output=$ARGV[1];
my @data = 0;


open(my $fh1, "<" , $input) or die "Could not open '$input' file$!";
open(my $fh2, ">", $output) or die "Could not open '$output' file$!";


while(<$fh1>){

    if ( $_ =~ /^@/ ){           ## Header part of SAM format should start '@'
        next;
    }

    if ( $_ !~ /^@/ ){
        @data = split( /\t/);
        my $checker = $data[1] & 0x10;  ## bitwise between FLAG and 0x10 
        if ( $checker == 0 ){          ## check the sequence is reverse or not
            print $fh2 ">$data[0]\n$data[9]\n";
            next;
        } 
        if ( $checker != 0) {  
            my $reverse = reverse $data[9];     ## reverse sequence
            print $fh2 ">$data[0]\n$reverse\n";
            next;
        }
    }
}   

close $fh1;
close $fh2;
