package Fullonsms;

use strict;
use warnings;

use Fullonsms::Session;
use Fullonsms::Message;

=head1 NAME

Fullonsms - An API to send sms in india via Fullonsms.com

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module takes your Fullonsms.com username and password and sends message to provided number.

    use Fullonsms::Session;
    use Fullonsms::Message;
    
    my $session = Fullonsms::Session->new(
        username    => 'your fullonsms username',
        password    => 'your fullonsms password',
    );
    $session->login;
    
    my $message = Fullonsms::Message->new(
        session             => $session,
        receiver_mobile_no  => [ 'mobile no 1', 'mobile no 2' ],
        message             => "wow this is working"
    );
    $message->send();

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Fullonsms
