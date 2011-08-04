package Fullonsms::Util;

use strict;
use warnings;

=head1 NAME

Fullonsms::Util - The great new Fullonsms::Util!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub base_url {
    return "http://www.fullonsms.com";
}

sub inform_user {
    my ( $message ) = @_;
    print "$message \n";
}

sub prepare_uri_as_string {
    my ( $url, $params ) = @_;
    my $uri = URI->new( $url );
    $uri->query_form(ref($params) eq "HASH" ? %$params : @$params);
    return $uri->as_string;
}

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Fullonsms::Util


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Fullonsms::Util
