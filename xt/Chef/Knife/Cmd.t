use Test::Most skip_all => 'requres a chef server';

use Chef::Knife::Cmd;

my $knife;
my $out;
my $node     = "eric";
my $expected = {
    name             => $node,
    chef_environment => "production",
    run_list         => ignore,
    normal           => ignore,
};

$knife = Chef::Knife::Cmd->new(logfile => 't/knife.log');
$out   = $knife->node->show($node);
like $out , qr/Node Name:\s+$node/, "knife node show $node";

$out   = $knife->node->show($node, format => 'json');
cmp_deeply $out, $expected, "knife node show $node --format json";

$knife = Chef::Knife::Cmd->new(logfile => 't/knife.log', format => 'json');
$out   = $knife->node->show($node);
cmp_deeply $out, $expected, "knife node show $node --format json (constructor)";

unlink 't/knife.log';

done_testing;
