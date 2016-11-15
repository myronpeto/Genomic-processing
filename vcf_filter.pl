#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(:config no_ignore_case bundling);
#use File::Temp qw/ tempfile tempdir /;
use IO::Zlib;
use Scalar::Util qw(looks_like_number);

###############################################################
#
# Processes data from vcf files. Generates bin counts of 
# mutations/base, GC content, and read count.
#Author: Myron Peto 
my $version = "1.0.0";

#Last revision: Feb 21st - 2012
#
my $usage = "perl dbsnp_file.vcf";
###############################################################

sub usage(){
  print STDERR "$usage\n";
  exit;
}



my $dbsnp_file =  $ARGV[0];
my $line1;
my $line2;
my @f_line;
my @length;
my $chr;
my $end1;
my $end2 = 0;
my $num = 0;
my $depth = 0;
my $pos = 0;
my %variant;
my %exons;
my $x;
my $count = 0;


open (FILE1, "<$dbsnp_file") or die ("Can't upen the file $dbsnp_file");
##print "The file opened is $ARGV[0]\n";

do {
	$line1 = <FILE1>;
	if ($line1) {
		chomp($line1);
		@f_line = split(/	/, $line1);
		if(substr ($f_line[0], 0, 1) ne '#') {
			$num = $f_line[0];
			$pos = $f_line[1];
			$count++;
			if ($num =~ 'X') {
				$num = 23;
			} elsif ($num =~ 'Y') {
				$num = 24;
			} elsif ($num =~ 'MT') {
				$num = 25;
			} elsif ($num =~ 'GL') {
				$num = 26;
			} else {
				$num = int($num);
			}
			$variant{$num}{$pos} = 1;
			if ($count % 1000000 == 0) {
				print $count, " lines read\n";
			}
		}
	}
} until (!($line1));


close (FILE1);



open (FILE1, "<nlist.txt") or die ("Can't upen the file nlist.txt");
##print "The file opened is $ARGV[0]\n";
my $fname;
my $fout;

do {
	$fname = <FILE1>;
	chomp ($fname);
	open (FILE2, "<$fname") or die ("Can't upen the file $fname");
	print "The file opened is $fname\n";
	my @temp = split(/_/, $fname);
	$fout = $temp[0] . "_calls_filtered.vcf";
	print "fout is: ", $fout, "\n";
	open (FOUT, ">$fout") or die  ("Can't upen the file $fout");
	print "The ouput file opened is $fout\n";
	do {
		$line1 = <FILE2>;
		if ($line1) {
			chomp($line1);
			@f_line = split(/	/, $line1);
			if(substr ($f_line[0], 0, 1) ne '#') {
				$num = $f_line[0];
				$pos = $f_line[1];
				if ($num =~ 'X') {
					$num = 23;
				} elsif ($num =~ 'Y') {
					$num = 24;
				} elsif ($num =~ 'MT') {
					$num = 25;
				} elsif ($num =~ 'GL') {
					$num = 26;
				} else {
					$num = int($num);
				}
				if(!$variant{$num}{$pos}) {
					print FOUT $line1, "\n";
				}
			} else {
				print FOUT $line1, "\n";
			}
		}
	} until (!($line1));
	close(FILE2);
	close(FOUT);
} until (!($fname));

close(FILE1);


#$count = 0;
#do {
#	$line2 = <FILE2>;
#	if ($line2) {
#		chomp($line2);
#		@f_line = split(/	/, $line2);
#		if (substr($f_line[0], 0, 1) ne '#') {
#			$num = $f_line[0];
#			$pos = $f_line[1];
#			$x = 0;
#			$count++;
#			if ($num =~ 'X') {
#				$num = 23;
#			} elsif ($num =~ 'Y') {
#				$num = 24;
#			} elsif ($num =~ 'MT') {
#				$num = 25;
#			}
#			if(!$variant{$num}{$pos}) {
#				print $line2, "\n";
#			}
#		} else {
#			print $line2, "\n";
#		}
#	}
#} until (!($line2) );

#close (FILE2);


	
