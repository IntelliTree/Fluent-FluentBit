INSTALLATION
------------

First, you need libfluent-bit.so

For debian-based containers:

    curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

Then, put the library in LD_PRELOAD.  (this is an unfortunate bug when
libfluent-bit is combined with Perl, and needs some deep C toolchain
debugging to resolve the problem)

    export LD_PRELOAD=/lib/fluent-bit/libfluent-bit.so

Now you can install the module:

    cpanm Fluent-LibFluentBit-0.01.tar.gz

or:

    tar -xf Fluent-LibFluentBit-0.01.tar.gz
    cd Fluent-LibFluentBit-0.01
    perl Makefile.PL
    make
    make test
    make install

DEVELOPMENT
-----------

Download or checkout the source code, then:

    dzil --authordeps | cpanm
    dzil test

To build and run single unit tests, use the 'dtest' script:

    ./dtest t/10-output-to-datadog.t

To build and install a trial version, use

    V=0.01_01 dzil build
    cpanm Fluent-LibFluentBit-0.01_01.tar.gz
