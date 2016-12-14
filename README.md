# NAME

Catmandu::Store::Datahub - Store/retrieve items from the Datahub

# SYNOPSIS

A module that allows to interface with the Datahub as a Catmandu::Store.

Supports retrieving, adding, deleting and updating of data.

# DESCRIPTION

Configure the [Datahub](https://github.com/thedatahub/Datahub) as a [store](http://librecat.org/Catmandu/#stores) for [Catmandu](http://librecat.org/).

With Catmandu, it is possible to convert (almost) any data to [LIDO](http://lido-schema.org/), which is suitable for importing in the Datahub. This module allows you to integrate the importing in your Catmandu workflow by setting up a Catmandu-compatible interface between the Datahub and Catmandu.

Note that you must convert your data to LIDO in order to use this module. All other formats will result in an error.

# CONFIGURATION

To configure the store, the location of the Datahub is required. As OAuth2 is used, a client id and secret are also required, as well as a username and a password.

* `url`: base url of the Datahub (e.g. http://www.datahub.be).
* `client_id`: OAuth2 client ID.
* `client_secret`: OAuth2 client secret.
* `username`: Datahub username.
* `password`: Datahub password.

# USAGE

See [the Catmandu documentation](http://librecat.org/Catmandu/#stores) for more information on how to use Stores.

# SEE ALSO

[Catmandu::LIDO](https://metacpan.org/pod/Catmandu::LIDO) and [Catmandu](https://metacpan.org/pod/Catmandu)

# AUTHORS

* Pieter De Praetere, `pieter at packed.be`
* Matthias Vandermaesen, `matthias.vandermaesen at vlaamsekunstcollectie.be`

# CONTRIBUTORS

* Pieter De Praetere, `pieter at packed.be`
* Matthias Vandermaesen, `matthias.vandermaesen at vlaamsekunstcollectie.be`

# COPYRIGHT AND LICENSE

The Perl software is copyright (c) 2016 by VKC vzw and PACKED vzw.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.
