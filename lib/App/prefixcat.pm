package App::prefixcat;

use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub run {
    my %opts = @_;

    my @ifh; # input handles
    my @ifnames;;
    if (@ARGV) {
        for (@ARGV) {
            my $ifh;
            if ($_ eq '-') {
                $ifh = *STDIN;
            } else {
                open $ifh, "<", $_ or die "Can't open input file $_: $!\n";
            }
            push @ifh, $ifh;
            push @ifnames, $_;
        }
    } else {
        push @ifh, *STDIN;
        push @ifnames, "-";
    }

    for my $filenum (1 .. @ifh) {
        my $ifh = $ifh[$filenum-1];
        my $ifname = $ifnames[$filenum-1];
        local $main::filename = $ifname;
        local $main::filenum = $filenum;
        my $linenum = 0;
        while (defined(my $line = <$ifh>)) {
            $linenum++;
            local $main::linenum = $linenum;
            if ($opts{eval}) {
                {
                    local $_ = $line;
                    my $res = $opts{eval}->($_);
                    print $res // $_;
                }
            } else {
                print sprintf($opts{format}, $ifname) . $opts{separator} . $line;
            }
        }
    }
}


1;
# ABSTRACT: Like Unix `cat` but by default prefix each line with filename

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

See the command-line script L<prefixcat>.

=cut
