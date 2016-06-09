use strict;
use warnings;

### DB Configuration : Please change here. =====
BEGIN {
    $ENV{KIKYO_DSN} ||= 'dbi:mysql:kikyo';
    $ENV{KIKYO_DBUSER} ||= 'root';
    $ENV{KIKYO_DBPASS} ||= '';
};
### ============================================

use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/lib/),
    glob(File::Spec->catdir(dirname(__FILE__), qw/modules * lib/)),
);
use Plack::Builder;
use Kikyo;

builder {
    enable "Static", path => qr{^/(app|bower_components)/}, root => './dashboard/';
    Kikyo->app;
};
