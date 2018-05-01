use v6.c;
unit module P5getgrnam:ver<0.0.1>:auth<cpan:ELIZABETH>;

use NativeCall;

my class GrStruct is repr<CStruct> {
    has Str         $.gr_name;
    has Str         $.gr_passwd;
    has uint32      $.gr_gid;
    has CArray[Str] $.gr_mem is rw;

    method result(:$scalar, :$gid) {
        if $scalar {
            $gid ?? $.gr_gid !! $.gr_name
        }
        else {
            ($.gr_name,$.gr_passwd,$.gr_gid,$.gr_mem)
        }
    }
}

my sub getgrnam(Str() $name, :$scalar) is export {
    sub _getgrnam(Str --> GrStruct) is native is symbol<getgrnam> {*}
    _getgrnam($name).result(:$scalar, :gid($scalar))
}

my sub getgrgid(Int() $gid, :$scalar) is export {
    sub _getgrgid(uint32 $gid --> GrStruct) is native is symbol<getgrgid> {*}
    my uint32 $ngid = $gid;
    _getgrgid($ngid).result(:$scalar)
}

my sub getgrent(:$scalar) is export {
    sub _getgrent(--> GrStruct) is native is symbol<getgrent> {*}
    with _getgrent() {
        .result(:$scalar)
    }
    else {
        $scalar ?? Nil !! ()
    }
}

my sub endgrent() is native is export {*}

=begin pod

=head1 NAME

P5getgrnam - Implement Perl 5's getgrnam() and associated built-ins

=head1 SYNOPSIS

    use P5getgrnam;

    my @result = getgrnam(~$*USER);

=head1 DESCRIPTION

This module tries to mimic the behaviour of the C<getgrnam> and associated
functions of Perl 5 as closely as possible.  It exports:

    endgrent getgrent getgrgid getgrnam

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/P5getgrnam . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Elizabeth Mattijsen

Re-imagined from Perl 5 as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod