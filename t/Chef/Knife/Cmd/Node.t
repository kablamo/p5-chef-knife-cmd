use Test::Most;
use 5.16.0;
use DDP;
use Devel::Confess;

use Chef::Knife::Cmd;

subtest 'noop tests' => sub {
    my $node  = 'arfarf';
    my $knife = Chef::Knife::Cmd->new(noop => 1);

    is $knife->node->show($node),
    "knife node show $node",
    "knife node show $node";

    is $knife->node->create($node, disable_editing => 1),
    "knife node create $node --disable-editing",
    "knife node create $node --disable-editing";

    is $knife->node->list(),
       "knife node list",
       "knife node list";

    is $knife->node->delete($node, yes => 1),
       "knife node delete $node --yes",
       "knife node delete $node --yes";

    my $env = 'production';
    is $knife->node->flip($node, $env),
       "knife node flip $node $env",
       "knife node flip $node $env";

    my $entries = [qw/a b/];
    is $knife->node->run_list->add($node, $entries),
       "knife node run_list add $node " . join(", ", @$entries),
       "knife node run_list add $node " . join(", ", @$entries);
};

subtest 'actually run knife node' => sub {
    my $node  = "eric";
    my $knife = Chef::Knife::Cmd->new(logfile => 't/knife.log');

    my ($merged_out, $value) = $knife->node->show($node);
    like $merged_out, qr/Node Name:\s+$node/, "knife node show $node";

    unlink 't/knife.log';
};

done_testing;
