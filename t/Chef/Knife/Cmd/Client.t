use Test::Most;
use 5.16.0;
use DDP;

use Chef::Knife::Cmd;

subtest 'noop tests' => sub {
    my $node  = 'arfarf';
    my $knife = Chef::Knife::Cmd->new(noop => 1);

    my $client = 'client';
    is $knife->client->delete($client),
       "knife client delete $client",
       "knife client delete $client";
};

done_testing;
