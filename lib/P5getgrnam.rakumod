use NativeCall;

# handling the result struct
my class GrStruct is repr<CStruct> {
    has Str         $.gr_name;
    has Str         $.gr_passwd;
    has uint32      $.gr_gid;
    has CArray[Str] $.gr_mem;

    multi method scalar(GrStruct:U:) { Nil }
    multi method list(GrStruct:U:) { ()  }

    multi method scalar(GrStruct:D: :$name) { $name ?? $.gr_name !! $.gr_gid }
    multi method list(GrStruct:D:) {
        my @members;
        with $.gr_mem -> $members {
            for 0..* {
                with $members[$_] -> $member {
                    @members.push($member)
                }
                else {
                    last
                }
            }
        }
        ($.gr_name,$.gr_passwd,$.gr_gid,@members.join(" "))
    }
}

# actual NativeCall interfaces
sub _getgrnam(Str --> GrStruct) is native is symbol<getgrnam> {*}
sub _getgrgid(uint32 $gid --> GrStruct) is native is symbol<getgrgid> {*}
sub _getgrent(--> GrStruct) is native is symbol<getgrent> {*}
sub _setgrent() is native is symbol<setgrent> {*}
sub _endgrent() is native is symbol<endgrent> {*}

# actual exported subs
my proto sub getgrnam(|) is export {*}
multi sub getgrnam(Scalar:U, Str() $name) { _getgrnam($name).scalar }
multi sub getgrnam(Str() $name) { _getgrnam($name).list }

my proto sub getgrgid(|) is export {*}
multi sub getgrgid(Scalar:U, Int() $gid) {
    my uint32 $ngid = $gid;
    _getgrgid($ngid).scalar(:name)
}
multi sub getgrgid(Int() $gid) {
    my uint32 $ngid = $gid;
    _getgrgid($ngid).list
}

my proto sub getgrent(|) is export {*}
multi sub getgrent(Scalar:U) { _getgrent.scalar }
multi sub getgrent() { _getgrent.list }

my sub setgrent() is export {
    _setgrent;
    1;  # this is apparently what Perl does, although not documented
}

my sub endgrent() is export {
    _endgrent;
    1;  # this is apparently what Perl does, although not documented
}

=begin pod

=head1 NAME

Raku port of Perl's getgrnam() and associated built-ins

=head1 SYNOPSIS

    use P5getgrnam;

    my @result = getgrnam(~$*USER);

=head1 DESCRIPTION

This module tries to mimic the behaviour of Perl's C<getgrnam> and associated
built-ins as closely as possible in the Raku Programming Language.

It exports:

    endgrent getgrent getgrgid getgrnam setgrent

=head1 ORIGINAL PERL 5 DOCUMENTATION

    getgrnam NAME
    getgrgid GID
    getgrent
    setgrent
    endgrent
            These routines are the same as their counterparts in the system C
            library. In list context, the return values from the various get
            routines are as follows:

             # 0        1          2           3         4
             ( $name,   $passwd,   $gid,       $members  ) = getgr*

            In scalar context, you get the name, unless the function was a
            lookup by name, in which case you get the other thing, whatever it
            is. (If the entry doesn't exist you get the undefined value.) For
            example:

                $gid   = getgrnam($name);
                $name  = getgrgid($num);

            The $members value returned by getgr*() is a space-separated list
            of the login names of the members of the group.

=head1 PORTING CAVEATS

This module depends on the availability of POSIX semantics.  This is
generally not available on Windows, so this module will probably not work
on Windows.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

Source can be located at: https://github.com/lizmat/P5getgrnam . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018, 2019, 2020, 2021, 2023 Elizabeth Mattijsen

Re-imagined from Perl as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
