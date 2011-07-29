#!/usr/bin/perl

use Fullonsms;

my $message = Fullonsms->new(
    username            => 'Your way2sms username',
    password            => 'Your way2sms password',
    receiver_mobile_no  => [ 'mobile no 1', 'mobile no 2' ],
    message             => "Wow this is working"
);

$message->send();