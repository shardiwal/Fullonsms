package Fullonsms;

use Moose;

use LWP::UserAgent;
use HTTP::Cookies;
use HTML::TagParser;

has 'username' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1
);

has 'password'  => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1
);

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

has 'browser'   => (
    is          => 'ro',
    isa         => 'LWP::UserAgent',
    default     => sub {
        my ( $self ) = @_;
        my $browser = LWP::UserAgent->new;
        $browser->cookie_jar(
            HTTP::Cookies->new( file => "lwpcookies.txt", autosave => 1 ) 
        );
        return $browser;
    }
);

has 'siteconfig'    => (
    is              => 'ro',
    isa             => 'HashRef',
    default         => sub {
        return {
            login_url           => 'http://www.fullonsms.com/CheckLogin.php',
            login_redirect_url  => 'http://www.fullonsms.com/home.php?Login=1',
            sms_url             => 'http://www.fullonsms.com/home.php',
        }
    }
);

sub _update_user {
    my ( $self, $message ) = @_;
    print "$message \n";
}

sub send {
    my ( $self ) = @_;
    my $browser = $self->browser;
    my $login_request = $browser->request(
        HTTP::Request->new( 
            POST => $self->_prepare_uri_as_string(
                $self->siteconfig->{login_url},
                [
                    MobileNoLogin => $self->username,
                    LoginPassword => $self->password,
                    x             => 13,
                    y             => 39
                ]                
            )
        )
    );
    my $response_code       = $login_request->code;
    my $response_content    = $login_request->decoded_content;

    $self->_update_user( "$response_code : Login" );
    my $login_redirect_url = $self->siteconfig->{login_redirect_url};
    if ( $self->_is_logged_id( $response_content ) )
    {
        my $request = $browser->request(
            HTTP::Request->new( GET => $login_redirect_url )
        );
        foreach my $receiver_mobile_no (@{$self->receiver_mobile_no}) {
            $self->_send_message( $browser, $receiver_mobile_no );
        }
    }
    else {
        $self->_update_user(" Login failed ");
    }
}

sub _prepare_uri_as_string {
    my ( $self, $url, $params ) = @_;
    my $uri = URI->new( $url );
    $uri->query_form(ref($params) eq "HASH" ? %$params : @$params);
    return $uri->as_string;
}

sub _send_message {
    my ( $self, $browser, $receiver_mobile_no ) = @_;
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
    }
    else {
        $self->_update_user("Message sending failed to $receiver_mobile_no");
    }
}

sub _is_logged_id {
    my ( $self, $response_content ) = @_;
    my $html = HTML::TagParser->new( $response_content );
    my @meta_tags = $html->getElementsByTagName("meta");
    my $result_found = 0;
    foreach my $meta_tag (@meta_tags) {
        my $attr = $meta_tag->attributes;
        foreach my $key ( sort keys %$attr ) {
            if (   $attr->{'http-equiv'} eq 'Refresh'
                and $attr->{'content'} =~/home\.php\?Login=1/
            ) {
                    $result_found = 1;
            }
        }
    }
    return $result_found;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;