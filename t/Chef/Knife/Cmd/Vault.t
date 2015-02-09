use Test::Most;

use Chef::Knife::Cmd;

my $node   = 'arfarf';
my $vault  = 'priv_keys';
my $item   = 'tarsnap';
my $values = '{ "yarf" : "gnarble", "yiff" : 1 }';
my $knife = Chef::Knife::Cmd->new(noop => 1);

is $knife->vault->create($vault, $item, $values),
    "knife vault create $vault $item '$values'",
    "knife vault create $vault $item '$values'";

my $cmd = $knife->vault->update($vault, $item, undef, 
    search => "name:$node", 
    mode   => "client",
);
is $cmd,
    "knife vault update $vault $item --mode client --search name:$node",
    "knife vault update $vault $item --mode client --search name:$node";

is $knife->vault->show($vault, $item),
    "knife vault show $vault $item",
    "knife vault show $vault $item";

done_testing;
