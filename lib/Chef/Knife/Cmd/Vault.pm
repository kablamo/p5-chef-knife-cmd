package Chef::Knife::Cmd::Vault;
use Moo;
use JSON::MaybeXS;

has knife => (is => 'ro', required => 1, handles => [qw/handle_options run/]);

sub create {
    my ($self, $vault, $item, $values, %options) = @_;
    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife vault create/, $vault, $item);
    push @cmd, $values if $values;
    push @cmd, @opts;
    $self->run(@cmd);
}

sub update {
    my ($self, $vault, $item, $values, %options) = @_;
    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife vault update/, $vault, $item);
    push @cmd, $values if $values;
    push @cmd, @opts;
    $self->run(@cmd);
}

sub show {
    my ($self, $vault, $item, %options) = @_;
    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife vault show/, $vault);
    push @cmd, $item if $item;
    push @cmd, @opts;
    $self->run(@cmd);
}

sub item {
    my ($self, $vault, $item, %options) = @_;
    my $json = $self->show($vault, $item, format => 'json', %options);
    return JSON->new->utf8->decode($json);
}

1;
