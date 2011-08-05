package Fullonsms::Session;

use Moose;
use HTML::TagParser;
use LWP::UserAgent;

use Fullonsms::Util;

=head1 NAME

Fullonsms::Session

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

has 'username' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'password' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'login_url' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return Fullonsms::Util::base_url . "/CheckLogin.php";
    }
);

has 'browser' => (
    is      => 'ro',
    isa     => 'LWP::UserAgent',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        my $browser = LWP::UserAgent->new;
        $browser->cookie_jar( {} );
        return $browser;
    }
);

=head1 SYNOPSIS

   my $session = Fullonsms::Session->new(
       username    => 'your fullonsms username',
       password    => 'your fullonsms password',
   );
   $session->login;

=head1 SUBROUTINES/METHODS

=head2 login

=cut

sub login {
    my ($self)        = @_;
    my $browser       = $self->browser;
    my $login_request = $browser->request(
        HTTP::Request->new(
            POST => Fullonsms::Util::prepare_uri_as_string(
                $self->login_url,
                [
                    MobileNoLogin => $self->username,
                    LoginPassword => $self->password,
                    x             => 13,
                    y             => 39
                ]
            )
        )
    );
    my $response_code    = $login_request->code;
    my $response_content = $login_request->decoded_content;

    if ( $self->_is_logged_id($response_content) ) {
        Fullonsms::Util::inform_user("$response_code : Login");
        return 1;
    }
    else {
        Fullonsms::Util::inform_user(" Login failed ");
        return undef;
    }
}

sub _is_logged_id {
    my ( $self, $response_content ) = @_;
    my $html         = HTML::TagParser->new($response_content);
    my @meta_tags    = $html->getElementsByTagName("meta");
    my $result_found = 0;
    foreach my $meta_tag (@meta_tags) {
        my $attr = $meta_tag->attributes;
        foreach my $key ( sort keys %$attr ) {
            if (    $attr->{'http-equiv'} eq 'Refresh'
                and $attr->{'content'} =~ /home\.php\?Login=1/ )
            {
                $result_found = 1;
            }
        }
    }
    return $result_found;
}

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Fullonsms::Session

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

no Moose;
__PACKAGE__->meta->make_immutable();

1; # End of Fullonsms::Session
