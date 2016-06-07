# NAME

Kikyo - Information Base for managing server assets

# DESCRIPTION

Kikyo is a Kikyo is a Information Base for managing server assets.

# HOW TO RUN

## mysql

First, create a database and a user on mysql-server. Then, create table with etc/schema.sql

## environment values

Set following environment values for database connection.

- KIKYO\_DSN - dns string for your database
- KIKYO\_DBUSER - database user
- KIKYO\_DBPASS - password for user authentication

Example.

    export KIKYO_DSN="dbi:mysql:host=10.0.0.1;database=kikyo"
    export KIKYO_DBUSER=kikyo
    export KIKYO_DBPASS=kiky0P@ss

Or, modify the app.psgi to conform to your database.

## plackup

Now, you can run Kikyo with plackup under Kikyo project directory.

# JSON API

## get racklist

    GET /v1/racklist

Returns list of rackname and host count.

## get rack info

    GET /v1/rack/{rackname}

Returns hosts list in specified rack.

## fetch host

    GET /v1/host/{hostid}

Returns specified host.

## search hosts

    GET /v1/search

Returns hosts list that matched for search query.

Available search parameters is following.

- id
- name
- rack
- ip
- hwid
- os
- modelname
- status

## add or update a host

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

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

https://github.com/ytnobody/kikyo-agent

# AUTHOR

ytnobody <ytnobody@gmail.com>

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 161:

    Unknown directive: =over4

- Around line 163:

    '=item' outside of any '=over'
