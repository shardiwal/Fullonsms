package Fullonsms::Message;

use Moose;
extends 'Fullonsms';

has 'receiver_mobile_no'  => (
    is          => 'rw',
    isa         => 'ArrayRef',
    required    => 1
);

has 'message'   => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1
);

has 'session'   => (
    is          => 'ro',
    isa         => 'HTTP::Cookies',
    required    => 1
);

sub send {
    my ( $self ) = @_;
    if ( $self->session ) {
        foreach my $receiver_mobile_no (@{$self->receiver_mobile_no}) {
            $self->_send_message( $receiver_mobile_no );
        }
    }
    else {
        $self->_update_user(" Login failed ");
    }
}

sub _send_message {
    my ( $self, $receiver_mobile_no ) = @_;
    my $browser = $self->browser;
    $browser->cookie_jar($self->session);

    my $smsrequest = $browser->request(
        HTTP::Request->new( POST => $self->_prepare_uri_as_string(
            $self->siteconfig->{sms_url},
            [
                CancelScript    => $self->siteconfig->{sms_url},
                MobileNos       => $receiver_mobile_no,
                SelGroup        => $receiver_mobile_no,
                Message         => $self->message,
                Gender          => 0,
                FriendName      => 'Your Friend Name',
                ETemplatesId    => '',
                TabValue        => 'contacts',
                IntSubmit       => 'Ok',
                IntCancel       => 'Cancel'
            ] )
        )
    );
    if ( $smsrequest->decoded_content =~ /MsgSent\.php/ ) {
        $self->_update_user("Message sent to : $receiver_mobile_no");
        return 1;
    }
    else {
        $self->_update_user("Message sending failed to $receiver_mobile_no");
        return 0;
    }
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
