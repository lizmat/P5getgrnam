use v6.*;
use Test;
use P5getgrnam;

my @supported = <
  endgrent getgrgid getgrent getgrnam setgrent
>.map: '&' ~ *;

plan @supported * 2;

for @supported {
    ok defined(::($_)),          "is $_ imported?";
    nok P5getgrnam::{$_}:exists, "is $_ NOT externally accessible?";
}

# vim: expandtab shiftwidth=4
