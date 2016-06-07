package Kikyo::DB;
use strict;
use warnings;
use Otogiri;

sub new {
    my ($class, @connect_info) = @_;
    $connect_info[0] ||= $ENV{KIKYO_DSN};
    $connect_info[1] ||= $ENV{KIKYO_DBUSER};
    $connect_info[2] ||= $ENV{KIKYO_DBPASS};
    Otogiri->new(connect_info => [@connect_info], strict => 0);
}

1;
