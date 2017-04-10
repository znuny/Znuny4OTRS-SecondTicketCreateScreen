# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::FixRedirect;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DBObject ConfigObject LogObject TimeObject MainObject LayoutObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Data!'
        );
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
    return $Param{Data}
        if $Self->{LayoutObject}->{UserCreateNextMask}
        && $Self->{LayoutObject}->{UserCreateNextMask} =~ /^(AgentTicketZoom|AgentZoom)/;

    # rewrite redirect
    ${ $Param{Data} } =~ s/Action=(AgentTicket(Phone|Email))/Action=$Self->{LayoutObject}->{Action}/;

    return $Param{Data};
}

1;
