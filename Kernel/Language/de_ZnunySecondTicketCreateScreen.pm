# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ZnunySecondTicketCreateScreen;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'New phone ticket 2'} = 'Neues Telefon-Ticket 2';
    $Self->{Translation}->{'New email ticket 2'} = 'Neues E-Mail-Ticket 2';

    return 1;
}

1;
