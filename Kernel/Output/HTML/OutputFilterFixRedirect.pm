# --
# Kernel/Output/HTML/OutputFilterFixRedirect.pm - fix redirect
# Copyright (C) 2014 Znuny GmbH, http://znuny.com/
# --

package Kernel::Output::HTML::OutputFilterFixRedirect;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject MainObject LayoutObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Data!' );
        $Self->{LayoutObject}->FatalDie();
    }

    # only work on redirects
    return $Param{Data} if !$Param{TemplateFile};
    return $Param{Data} if $Param{TemplateFile} !~ /^redirect/i;

    # return if it's not email or phone ticket
    return $Param{Data} if $Self->{LayoutObject}->{Action} !~ /^AgentTicket(Phone|Email)/;

    # do not redirect CTI called redirect's
    return $Param{Data} if $Self->{LayoutObject}->{Action} =~ /CTI/;

    # return if redirect is not to create screen again
    return $Param{Data} if $Self->{LayoutObject}->{UserCreateNextMask} && $Self->{LayoutObject}->{UserCreateNextMask} =~ /^(AgentTicketZoom|AgentZoom)/;

    # rewrite redirect
    ${ $Param{Data} } =~ s/Action=(AgentTicket(Phone|Email))/Action=$Self->{LayoutObject}->{Action}/;

    return $Param{Data};
}

1;
