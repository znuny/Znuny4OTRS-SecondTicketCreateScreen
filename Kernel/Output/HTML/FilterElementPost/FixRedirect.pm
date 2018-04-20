# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::FixRedirect;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !defined $Param{Data} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need Data!'
        );
        $LayoutObject->FatalDie();
    }

    # only work on redirects
    return if !$Param{TemplateFile};
    return if $Param{TemplateFile} !~ m{\Aredirect}i;

    # return if it's not second email or phone ticket action
    return if $LayoutObject->{Action} !~ m{\AAgentTicket(Phone|Email)Second\z};

    #     # ignore CTI redirects
    #     return if $LayoutObject->{Action} =~ m{CTI};

    # return if redirect is not to create screen again
    return
        if defined $LayoutObject->{UserCreateNextMask}
        && $LayoutObject->{UserCreateNextMask} =~ m{\AAgent(Ticket)?Zoom};

    # rewrite redirect
    ${ $Param{Data} } =~ s{Action=(AgentTicket(Phone|Email))}{Action=$LayoutObject->{Action}};

    return;
}

1;
