package Fullonsms;

use Moose;
use LWP::UserAgent;

has 'browser'   => (
    is          => 'ro',
    isa         => 'LWP::UserAgent',
    default     => sub {
        my ( $self ) = @_;
        my $browser = LWP::UserAgent->new;
        $browser->cookie_jar({});
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

sub _prepare_uri_as_string {
    my ( $self, $url, $params ) = @_;
    my $uri = URI->new( $url );
    $uri->query_form(ref($params) eq "HASH" ? %$params : @$params);
    return $uri->as_string;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
