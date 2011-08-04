package Fullonsms::Message;

use Moose;
use Fullonsms::Util;

=head1 NAME

Fullonsms::Message

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

has 'receiver_mobile_no' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => 1
);

has 'message' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'session' => (
    is       => 'ro',
    isa      => 'Fullonsms::Session',
    required => 1
);

has 'sms_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        return Fullonsms::Util::base_url . "/home.php";
    }
);


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Fullonsms::Message;

    my $message = Fullonsms::Message->new(
        session             => $session,
        receiver_mobile_no  => [ 'mobile no 1', 'mobile no 2' ],
        message             => "wow this is working"
    );
    $message->send();

=head1 SUBROUTINES/METHODS

=head2 send

=cut

sub send {
    my ($self) = @_;
    if ( $self->session ) {
        foreach my $receiver_mobile_no ( @{ $self->receiver_mobile_no } ) {
            $self->_send_message($receiver_mobile_no);
        }
    }
    else {
        Fullonsms::Util::inform_user(" Login failed ");
    }
}

sub _send_message {
    my ( $self, $receiver_mobile_no ) = @_;
    my $browser    = $self->session->browser;
    my $smsrequest = $browser->request(
        HTTP::Request->new(
            POST => Fullonsms::Util::prepare_uri_as_string(
                $self->sms_url,
                [
                    CancelScript => $self->sms_url,
                    MobileNos    => $receiver_mobile_no,
                    SelGroup     => $receiver_mobile_no,
                    Message      => $self->message,
                    Gender       => 0,
                    FriendName   => 'Your Friend Name',
                    ETemplatesId => '',
                    TabValue     => 'contacts',
                    IntSubmit    => 'Ok',
                    IntCancel    => 'Cancel'
                ]
            )
        )
    );
    if ( $smsrequest->decoded_content =~ /MsgSent\.php/ ) {
        Fullonsms::Util::inform_user("Message sent to : $receiver_mobile_no");
        return 1;
    }
    else {
        Fullonsms::Util::inform_user(
            "Message sending failed to $receiver_mobile_no");
        return 0;
    }
}

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Fullonsms::Message

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

no Moose;
__PACKAGE__->meta->make_immutable();

1; # End of Fullonsms::Message
