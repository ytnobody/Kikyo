use strict;
use warnings;
use lib qw(lib);
use Plack::Builder;
use Kikyo;

BEGIN {
    $ENV{KIKYO_DSN} = 'dbi:mysql:kikyo';
    $ENV{KIKYO_DBUSER} = 'root';
    $ENV{KIKYO_DBPASS} = '';
};

builder {
    Kikyo->app;
};
