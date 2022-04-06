#!/usr/bin/perl -s
use Scalar::Util qw (looks_like_number);

our $w;
our $s;
my $string = "";

sub rand_string{ # Random character string
	my $len = shift;
	my $output;
	my @chars;
	if($s) {
		@chars = ('A'..'Z', 'a'..'z', 0..9, '!', '@', '%', '&', '_', '$',
				 '#', '^', '*', '+', '=', '~', '<', '?', '>', '[', ']');
	} else {
		@chars = ('A'..'Z', 'a'..'z', 0..9);
	}	

	# If we're not given a number.
	if (!looks_like_number($len)) { 
		$len = 8; 
	}

	# Set the length to min or max lengths if outside bounds.
	if ($len < 8) { 
		$len = 8; 
	} elsif ($len > 20) { 
		$len = 20; 
	}

	for (1..$len) {
		$output .= $chars[int rand(@chars)];
	}
	return $output;
}

sub rand_words{ # XKCD Mode
	my $words_file = "/etc/dictionaries-common/words";
	my @words;
	my $output = "";

	open(my $FH, '<', $words_file) or die $!;

	# Filter word list.
	while (my $word = <$FH>) {
		chomp $word;
		next if $word !~ /^\w+$/gm; #Skip if not a word
		next if(length($word) > 8); #Skip if longer than 8 characters
		next if(length($word) < 4); #Skip if shorter than 4 characters
		push @words, $word; 
	}
	
	# Grab 2 words.
	for (1..2) {
		my $sel = $words[int rand(@words)];
		while (lc($output) eq lc($sel)) {
			$sel = $words[int rand(@words)];
		}
		substr($sel, 0, 1) = uc(substr($sel, 0, 1));
		$output .= $sel;
	}
	return $output;
}

my $string;
if ($w) { # If we're passed -w
	$string = rand_words();
} else { # Default behavior
	$string = rand_string(shift);
}

print "===[ " . $string . " ]===\n";
