[![Actions Status](https://github.com/lizmat/P5getgrnam/workflows/test/badge.svg)](https://github.com/lizmat/P5getgrnam/actions)

NAME
====

Raku port of Perl's getgrnam() and associated built-ins

SYNOPSIS
========

    use P5getgrnam;

    my @result = getgrnam(~$*USER);

DESCRIPTION
===========

This module tries to mimic the behaviour of Perl's `getgrnam` and associated built-ins as closely as possible in the Raku Programming Language.

It exports:

    endgrent getgrent getgrgid getgrnam setgrent

ORIGINAL PERL 5 DOCUMENTATION
=============================

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

PORTING CAVEATS
===============

This module depends on the availability of POSIX semantics. This is generally not available on Windows, so this module will probably not work on Windows.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/P5getgrnam . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2019, 2020, 2021 Elizabeth Mattijsen

Re-imagined from Perl as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

