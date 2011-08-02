package Fullonsms::Session;

use Moose;
extends 'Fullonsms';

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

sub login {
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

    my $login_redirect_url = $self->siteconfig->{login_redirect_url};
    if ( $self->_is_logged_id( $response_content ) )
    {
        $self->_update_user( "$response_code : Login" );
        my $request = $browser->request(
            HTTP::Request->new( GET => $login_redirect_url )
        );
        return $browser->cookie_jar;
    }
    else {
        $self->_update_user(" Login failed ");
        return undef;
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
