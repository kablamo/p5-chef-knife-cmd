package Chef::Knife::Cmd;
use feature qw/say/;
use Moo;

use Chef::Knife::Cmd::Client;
use Chef::Knife::Cmd::EC2;
use Chef::Knife::Cmd::Node;
use Chef::Knife::Cmd::Vault;
use Shell::Carapace;
use String::ShellQuote;

our $VERSION = "0.01";

=head1 NAME

Chef::Knife::Cmd - A small wrapper around Chef's cmd line utility 'knife'

=head1 SYNOPSIS

    use Chef::Knife::Cmd;

    my $knife = Chef::Knife::Cmd->new(
        verbose   => 1,           # tee output to STDOUT
        logfile   => 'knife.log', # all cmd output logged here
        print_cmd => 1,           # if you want knife cmd printed to STDOUT
    );

    # knife bootstrap
    $knife->bootstrap($fqdn, %options);

    # knife client
    $knife->client->delete($client, %options);

    # knife ec2
    $knife->ec2->server->list(%options);
    $knife->ec2->server->create(%options);
    $knife->ec2->server->delete(\@nodes, %options);

    # knife node
    $knife->node->show($node, %options);
    $knife->node->list($node, %options);
    $knife->node->create($node, %options);
    $knife->node->delete($node, %options);
    $knife->node->flip($node, $environment, %options);
    $knife->node->run_list->add($node, \@entries, %options);

    # knife vault commands
    # hint: use $knife->vault->item() instead of $knife->vault->show()
    $knife->vault->create($vault, $item, $values, %options);
    $knife->vault->update($vault, $item, $values, %options);
    $knife->vault->show($vault, $item_name, %options);
    my $item = $knife->vault->item($vault, $item_name, %options);
    say $item->{secret};
    say $item->{super_secret};

=head1 DESCRIPTION

This module is a small wrapper around Chef's command line utility, 'knife'.  

It would be awesome if this module used the Chef server API, but this module is
not that awesome.

Some things to know about this module:

=over 4

=item Return vaules

All commands return the output of the knife command.  

=item Logging

All knife cmd output is logged to a logfile for later analysis.  This allows
you to provide verbose logging to users while not cluttering their terminal
with tons of output.

=item Tee output to STDOUT

Instead of waiting for an hour for a knife command to finish, you can view
output from the knife command in real time as it happens.  This happens when
the 'verbose' attribute is true.

=item Exceptions

If a knife command fails, this module will throw an exception.

=item No need to mess about with string manipulation

Yay.

=back

=cut

has verbose   => (is => 'rw', default => sub { 0 });
has print_cmd => (is => 'rw', default => sub { 0 });
has noop      => (is => 'rw', default => sub { 0 });
has shell     => (is => 'lazy');
has logfile   => (is => 'ro', default => sub { 'knife.log' });

has client    => (is => 'lazy');
has ec2       => (is => 'lazy');
has node      => (is => 'lazy');
has vault     => (is => 'lazy');

sub _build_client    { Chef::Knife::Cmd::Client->new(knife => shift)    }
sub _build_ec2       { Chef::Knife::Cmd::EC2->new(knife => shift)       }
sub _build_node      { Chef::Knife::Cmd::Node->new(knife => shift)      }
sub _build_vault     { Chef::Knife::Cmd::Vault->new(knife => shift)     }

sub _build_shell {
    my $self = shift;
    return Shell::Carapace->new(
        print_cmd => $self->print_cmd(),
        verbose   => $self->verbose(),
        logfile   => $self->logfile(),
        noop      => $self->noop(),
    );
}

sub bootstrap {
    my ($self, $fqdn, %options) = @_;
    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife bootstrap/, $fqdn, @opts);
    $self->run(@cmd);
}

sub handle_options {
    my ($self, %options) = @_;

    my @opts;
    for my $option (sort keys %options) {
        my $value = $options{$option};
        $option =~ s/_/-/g;

        push @opts, "--$option";
        push @opts, $value if $value ne "1";
    }

    return @opts;
}

sub handle_optionsx {
    my ($self, %options) = @_;

    my $cmd = "";
    for my $opt (sort keys %options) {
        my $value = $options{$opt};
        $opt =~ s/_/-/g;

        $cmd .= " --$opt";
        $cmd .= " '$value'" if $value ne "1";
    }

    return $cmd;
}

sub run {
    my ($self, @cmds) = @_;
    $self->shell->local(@cmds);
}

1;

=head1 SEE ALSO

=over 4

=item Capture::Tiny::Extended

=item Capture::Tiny

=item IPC::System::Simple

=back

=head1 ABOUT THE NAME

I didn't name this Chef::Knife because I'm hoping someone someday will write a
real Chef::Knife module which uses the Chef server API.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Eric Johnson E<lt>eric.git@iijo.orgE<gt>

=cut
