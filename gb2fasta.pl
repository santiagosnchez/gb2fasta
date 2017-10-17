#!/usr/bin/perl

##########################################################
# USAGE:						 #
#							 #
# >> perl gb2fasta.pl <genebank_file.gb> <outfile.fasta> #
#							 #
# the first file ("file.gb") must be in genebank format  #
# the second one will be the file where the fasta seqs   #
# will be printed to.					 #
# This script has the capability of retrieving data from #
# the "souce" genebank section. In particular info about #
# the geographic location and the voucher number.        #
#							 #
# ©SantiagoSanchez 2012					 #
#							 #
##########################################################

my $usage = "\nTry:\nperl gb2fasta.pl -gb <gb.file> -out <outfile.fasta> [options]
Options:
-geo    will include only records with a geographic location
-oc     will only include the country if the record has a geographic location
-nv     will exclude the voucher label\n";
my $gbfile;
my $outfile;
my $geoOnly;
my $countryOnly;
my $noVouch;
my @geo = ();
my @all = ();
my @line = ();
my @acc = ();
my @tax = ();
my @vouch = ();
my @loc = ();
my @numVouch=();
my @numLoc=();
my @sequence = ();
my $source;

if ($ARGV[0] =~ m/-h/){
	die "$usage\n";
} else {
	for (my $i=0; $i<scalar(@ARGV); ++$i){
		if ($ARGV[$i] eq "-gb"){
			$gbfile = $ARGV[$i+1];
		}
		if ($ARGV[$i] eq "-out"){
			$outfile = $ARGV[$i+1];
		}
		if ($ARGV[$i] eq "-geo"){
			$geoOnly = 1;
		}
		if ($ARGV[$i] eq "-oc"){
			$countryOnly = 1;
		}
		if ($ARGV[$i] eq "-nv"){
			$noVouch = 1;
		}
	}
}

open (OUTFILE, ">$outfile");
open (GBFILE, $gbfile);
local $/ = "\n\/\/\n";
while (<GBFILE>){
	if ($_ =~ m/\/country\=/){
		push (@geo, $_);
	}
	push (@all, $_);
}

pop(@all);

if ($geoOnly == 1){
	foreach (@geo){
		@line = split("\n", $_);
		foreach (@line){
			if ($_=~m/ACCESSION/){
				$_ =~ s/^ACCESSION +/>/;
				push (@acc, $_);
			}
			if ($_=~m/\/organism\=/){
				$_ =~ s/ +\/organism\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/\.|'|\(|\)|"|,//g;
				$_ =~ s/__/_/g;
				push (@tax, $_);
			}
		}
		my @seq = split("ORIGIN", $_);
		chomp($seq[1]);
		$seq[1] =~ s/[0-9]| |\n//g;
		$seq[1] =~ tr/a-z/A-Z/;
		push (@sequence, $seq[1]);
		$source = substr($_, 0, length($_));
		#if ($source =~m/(\/specimen_voucher\=|\/isolate\=|\/clone\=|\/strain\=)/){
		my @onevouch=();
		foreach (@line){
			if ($_=~m/\/specimen_voucher\=/){
				$_ =~ s/ +\/specimen_voucher\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
			elsif ($_=~m/\/isolate\=/){
				$_ =~ s/ +\/isolate\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
				$onevouch = 1;
			}
			elsif ($_=~m/\/clone\=/){
				$_ =~ s/ +\/clone\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
			elsif ($_=~m/\/strain\=/){
				$_ =~ s/ +\/strain\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
		}
		if (scalar(@onevouch) == 0){
			push (@vouch, "NA");
		} else {
			push (@vouch, @onevouch[0]);
			push (@numVouch, 1);
		}
		if ($source =~m/\/country\=/){
			foreach (@line){
				if ($_=~m/\/country\=/){
					$_ =~ s/ +\/country\=//;
					$_ =~ s/"//g;
					$_ =~ s/:/@/;
					$_ =~ s/ |-/_/g;
					$_ =~ s/,|\[|\]|\.|,|'|\(|\)|-|\///g;
					$_ =~ s/__/_/g;
					if ($_ =~ m/_/){
						#@temp = split("_", $_);
						#$_ = '_'.$temp[1];
						push (@loc, $_);
						push (@numLoc, 1);
					} else {
						push (@loc, $_);
						push (@numLoc, 1);
					}
				}
			}
		} else {
			push (@loc, "NA");
		}
	}
} else {
	foreach (@all){
		@line = split("\n", $_);
		foreach (@line){
			if ($_=~m/ACCESSION/){
				$_ =~ s/^ACCESSION +/>/;
				push (@acc, $_);
			}
			if ($_=~m/\/organism\=/){
				$_ =~ s/ +\/organism\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/\.|'|\(|\)|"|,//g;
				$_ =~ s/__/_/g;
				push (@tax, $_);
			}
		}
		my @seq = split("ORIGIN", $_);
		chomp($seq[1]);
		$seq[1] =~ s/[0-9]| |\n//g;
		$seq[1] =~ tr/a-z/A-Z/;
		push (@sequence, $seq[1]);
		$source = substr($_, 0, length($_));
		#if ($source =~m/(\/specimen_voucher\=|\/isolate\=|\/clone\=|\/strain\=)/){
		my @onevouch=();
		foreach (@line){
			if ($_=~m/\/specimen_voucher\=/){
				$_ =~ s/ +\/specimen_voucher\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
			elsif ($_=~m/\/isolate\=/){
				$_ =~ s/ +\/isolate\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
				$onevouch = 1;
			}
			elsif ($_=~m/\/clone\=/){
				$_ =~ s/ +\/clone\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
			elsif ($_=~m/\/strain\=/){
				$_ =~ s/ +\/strain\=//;
				$_ =~ s/"//g;
				$_ =~ s/ |-/_/g;
				$_ =~ s/,|\[|\]|\.|'|\(|\)|:|-|\///g;
				$_ =~ s/__/_/g;
				push (@onevouch, $_);
				#push (@vouchNum, $_);
			}
		}
		if (scalar(@onevouch) == 0){
			push (@vouch, "NA");
		} else {
			push (@vouch, @onevouch[0]);
			push (@numVouch, 1);
		}
		if ($source =~m/\/country\=/){
			foreach (@line){
				if ($_=~m/\/country\=/){
					$_ =~ s/ +\/country\=//;
					$_ =~ s/"//g;
					$_ =~ s/:/@/;
					$_ =~ s/ |-/_/g;
					$_ =~ s/,|\[|\]|\.|,|'|\(|\)|-|\///g;
					$_ =~ s/__/_/g;
					if ($_ =~ m/_/){
						#@temp = split("_", $_);
						#$_ = '_'.$temp[1];
						push (@loc, $_);
						push (@numLoc, 1);
					} else {
						push (@loc, $_);
						push (@numLoc, 1);
					}
				}
			}
		} else {
			push (@loc, "NA");
		}
	}
}
#pop(@loc);
#pop(@vouch);
#pop(@numVouch);
#pop(@numLoc);
#pop(@sequence);

$c1 = scalar(@numVouch);
$c2 = scalar(@numLoc);
$c3 = scalar(@all);
$c4 = scalar(@sequence);
for (my $i=0;$i<scalar(@vouch);++$i){
	if ($countryOnly = 1){
		if (($loc[$i] ne 'NA') and ($loc[$i] =~ m/@/)){
			if ($noVouch == 1){
				$head = $acc[$i] . "__" . $tax[$i] . "__" . substr($loc[$i],0,index($loc[$i],'@'));
			} else {
				$head = $acc[$i] . "__" . $tax[$i] . "__" . $vouch[$i] . "__" . substr($loc[$i],0,index($loc[$i],'@'));
			}
		} else {
			if ($noVouch == 1){
				$head = $acc[$i] . "__" . $tax[$i] . "__" . $loc[$i];
			} else {
				$head = $acc[$i] . "__" . $tax[$i] . "__" . $vouch[$i] . "__" . $loc[$i];
			}
		}
	} else {
		if ($noVouch == 1){
			$head = $acc[$i] . "__" . $tax[$i] . "__" . $loc[$i];
		} else {
			$head = $acc[$i] . "__" . $tax[$i] . "__" . $vouch[$i] . "__" . $loc[$i];
		}
	}	
	#$head =~ s/__/_/g;
	print OUTFILE "$head\n$sequence[$i]\n\n";
}
close (OUTFILE);
if ($geoOnly == 1){
	print "\nThe option \"-geo\" was parsed. Only sequences with a geographic location will be printed\n";
}
print "\n###################\nNumber of records parsed: $c3\nNumber of records with a geographic location: $c2\nNumber of records with a voucher number: $c1\nNumber of sequences: $c4\n###################\n\n"
