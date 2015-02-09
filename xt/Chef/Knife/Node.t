use Test::Most skip_all => 'requres a chef server';

use Chef::Knife::Cmd;

my $node  = "eric";
my $knife = Chef::Knife::Cmd->new(logfile => 't/knife.log');

my ($merged_out, $value) = $knife->node->show($node);
like $merged_out, qr/Node Name:\s+$node/, "knife node show $node";

unlink 't/knife.log';

done_testing;
