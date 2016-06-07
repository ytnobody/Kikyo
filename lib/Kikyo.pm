package Kikyo;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Amagi;
use Kikyo::DB;
use Time::Piece;

our $DBC;

sub db () {
    my $time = time;
    if ($DBC && $time - $DBC->[0] > 600) {
        $DBC = undef;
    }
    $DBC ||= [ $time, Kikyo::DB->new ];
    $DBC->[1];
}

get '/v1/rack/:rack' => sub {
    my ($app, $req) = @_;
    my %rows = (map {$_->{unit} => $_} db->select(host => {rack => $req->captured->{rack}}));
    {
        rows => [reverse map {$rows{$_}} 1..42]
    };
};

get '/v1/host/:id' => sub {
    my ($app, $req) = @_;
    my $host = db->single(host => {id => $req->captured->{id}});
    { host => $host };
};

get '/v1/racklist' => sub {
    my ($app, $req) = @_;
    { 
        rows => [map {$_->{hosts} += 0; $_} db->search_by_sql('SELECT rack, COUNT(unit) AS hosts FROM host GROUP BY rack ORDER BY rack')]
    }
};

get '/v1/search' => sub {
    my ($app, $req) = @_;
    my $query = __PACKAGE__->search_query($req->parameters->mixed);
    { rows => [map {__PACKAGE__->recast_host_fields($_)} db->select(host => $query)] };
};

post '/v1/rack/:rack/:unit' => sub {
    my ($app, $req) = @_;
    my $input = $req->json_content or return $app->res_error(400 => 'Bad Request');
    my $now = localtime->strftime('%Y-%m-%d %H:%M:%S');
    my $id = delete $input->{id};
    if ($id) {
        db->update(host => {%$input, %{$req->captured}}, {id => $id});
    }
    else {
        db->insert(host => {%$input, %{$req->captured}, create_at => $now});
        $id = db->last_insert_id;
    }
    my $host = db->single(host => {id => $id});
    {host => __PACKAGE__->recast_host_fields($host)};
};

sub search_query {
    my ($class, $params) = @_;
    my $query = +{ map {$_ => $params->{$_}} grep {defined $params->{$_}} qw/id ip name rack hwid os modelname status/ };
    my $key;
    for $key (qw/ip name os modelname/) {
        next unless defined $query->{$key};
        $query->{$key} = {LIKE => sprintf "%%%s%%", $query->{$key}};
    }
    for $key (qw/rack/) {
        next unless defined $query->{$key};
        $query->{$key} = {LIKE => sprintf "%s%%", $query->{$key}};
    }
    return $query;
}

sub recast_host_fields {
    my ($class, $host) = @_;
    my $rtn = {%$host};
    $rtn->{$_} = $rtn->{$_} +0 for qw/id unit/;
    return $rtn;
}

1;
__END__

=encoding utf-8

=head1 NAME

Kikyo - Information Base for managing server assets

=head1 DESCRIPTION

Kikyo is a Kikyo is a Information Base for managing server assets.

=head1 HOW TO RUN

=head2 mysql

First, create a database and a user on mysql-server. Then, create table with etc/schema.sql

=head2 environment values

Set following environment values for database connection.

=over 4

=item KIKYO_DSN - dns string for your database

=item KIKYO_DBUSER - database user

=item KIKYO_DBPASS - password for user authentication

=back

Example.

    export KIKYO_DSN="dbi:mysql:host=10.0.0.1;database=kikyo"
    export KIKYO_DBUSER=kikyo
    export KIKYO_DBPASS=kiky0P@ss

=head2 plackup

Now, you can run Kikyo with plackup under Kikyo project directory.

=head1 JSON API

=head2 get racklist

    GET /v1/racklist

Returns list of rackname and host count.

=head2 get rack info

    GET /v1/rack/{rackname}

Returns hosts list in specified rack.

=head2 fetch host

    GET /v1/host/{hostid}

Returns specified host.

=head2 search hosts

    GET /v1/search

Returns hosts list that matched for search query.

Available search parameters is following.

=over4

=item id

=item name

=item rack

=item ip

=item hwid

=item os

=item modelname

=item status

=back

=head2 add or update a host

    POST /v1/rack/{rackname}/{unit-id}

Add or update a host information.

Request example.

Add

    POST /v1/rack/tokyo-0103/22 HTTP/1.1
    Content-Type: application/json
    
    {"name":"www101","cpu":"Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz x 4Core","memory":"16GB","disk":"500GB","os":"ubuntu 16.04","ip":"10.0.100.101/24, 10.0.200.101/24"}


Update

    POST /v1/rack/tokyo-0103/23 HTTP/1.1
    Content-Type: application/json
    
    {"id":1,"name":"www101","cpu":"Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz x 4Core","memory":"16GB","disk":"500GB","os":"ubuntu 16.04","ip":"10.0.100.101/24, 10.0.200.101/24"}


=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

https://github.com/ytnobody/kikyo-agent

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

