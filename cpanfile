requires 'perl', '5.008001';

### for Kikyo
requires 'Time::Piece';
requires 'DBD::mysql';
requires 'Otogiri';

### for Amagi
requires 'Router::Boom';
requires 'Plack';
requires 'Plack::Request::WithEncoding';
requires 'JSON';
requires 'Class::Accessor::Lite';
requires 'Digest::SHA';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

