package Chef::Knife::Cmd::Node::From;
use Moo;

has knife => (is => 'ro', required => 1, handles => [qw/run handle_options/]);

sub file {
    my ($self, $node, $file, %options) = @_;

    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife node from file/, $node, $file, @opts);
    $self->run(@cmd);
}

1;
