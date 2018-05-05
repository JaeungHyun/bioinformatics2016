#!/usr/bin/perl
use warnings;
use strict;

my $input=$ARGV[0];
my $output=$ARGV[1];
my $qual_length = 0;
my $seq_length = 0;


open(my $fh1, "<" , $input) or die "Could not open '$input' file$!";
open(my $fh2, ">", $output) or die "Could not open '$output' file$!";


while(<$fh1>){                       
    if ( $_ =~ /^@/ ){               ## 문자열이 @로 시작하면 조건문 실행
        s/^@/>/;                     ## 각 라인의 맨 앞 쪽에 있는 @를 '>'로 변경
        print $fh2 "$_";
        $seq_length = 0;
        next;                     
    }
    
    if ( $_ !~ /^\+/ ){               
        $seq_length += length($_);                              
        print $fh2 "$_"; 
        next;                         
    }

    if ( $_ =~ /^\+/){  
        $qual_length = 0;                       
        while(<$fh1>){                                                
            $qual_length += length($_);     
            if ( $seq_length <= $qual_length){
                last;         ## 서열의 길이와 퀄리티 값의 길이가 같아지면 작아지면 루프 아웃                                                       
            }
        }
    }
}
    
close $fh1;
close $fh2;