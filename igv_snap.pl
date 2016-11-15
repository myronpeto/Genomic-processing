#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(:config no_ignore_case bundling);
use IO::Zlib;
use Scalar::Util qw(looks_like_number);

###############################################################
#
# Processes data from paired-end DNA sequence in two fastq files. 
# Checks for fixed sequences at the beginning of the paired reads.
# Chops the fixed sequences off, leaving the rest to be aligned.
#  
#Author: Myron Peto 
my $version = "0.1.0";

#Last revision: July 24th - 2015
#
my $usage = "perl igv_snap.pl mutation_list";
################################################################

sub usage(){
	print STDERR "$usage\n";
	exit;
}



my $m_file =  $ARGV[0];
my $line;
my @genes;
my @mutation;
my $x = 1;
my $previous;


open (FILE1, "<$m_file") or die ("Can't upen the file $m_file");
# print "The file opened is $ARGV[0]\n";


do {
   	$line = <FILE1>;
	if ($line) {
   		chomp($line);
   		@genes = split /	/, $line;
   		@mutation = split /_/, $genes[0];
   		if ($mutation[0] ne $previous) {
   			print "new\n";
   			print "load /mnt/lustre1/users/peto/Baylor/all_vcf/bams/", $mutation[0], ".bam\n";
   			print "snapshotDirectory /mnt/lustre1/users/peto/Baylor/all_vcf/snapshots\n";
   			print "genome hg19\n\n";
   			$x = 1;
   			$previous = $mutation[0];
   		}
   		print "goto chr", $genes[5], ":", $genes[6]-100, "-", $genes[6]+100, "\n";
   		print "sort position\n";
   		print "collapse\n";
   		print "snapshot ", $mutation[0], "_", $x, ".jpg\n\n";
   		$x++;
   	}
} until (!($line));



close (FILE1);
