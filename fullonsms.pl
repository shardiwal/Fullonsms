#!/usr/bin/perl

use Fullonsms::Session;
use Fullonsms::Message;

my $session = Fullonsms::Session->new(
    username    => 'your fullonsms username',
    password    => 'your fullonsms password',
)->login;

my $message = Fullonsms::Message->new(
    session             => $session,
    receiver_mobile_no  => [ 'mobile no 1', ' mobile no 2' ],
    message             => "Wow this is working"
);
$message->send();
