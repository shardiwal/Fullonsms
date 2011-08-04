#!/usr/bin/perl

use strict;
use warnings;

use Fullonsms::Session;
use Fullonsms::Message;

my $user = Fullonsms::Session->new(
    username    => 'your fullonsms username',
    password    => 'your fullonsms password',
);
my $session = $user->login;

my $message = Fullonsms::Message->new(
    session             => $session,
    receiver_mobile_no  => [ 'mobile no 1', 'mobile no 2' ],
    message             => "wow this is working"
);
$message->send();
