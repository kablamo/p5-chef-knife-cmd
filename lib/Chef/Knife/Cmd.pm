package Chef::Knife::Cmd;
use feature qw/say/;
use Moo;

use Chef::Knife::Cmd::Client;
use Chef::Knife::Cmd::EC2;
use Chef::Knife::Cmd::Node;
use Chef::Knife::Cmd::Vault;
use Shell::Carapace;
use String::ShellQuote;
use JSON::MaybeXS;

our $VERSION = "0.03";

=head1 NAME

Chef::Knife::Cmd - A small wrapper around the Chef 'knife' command line utility

=head1 SYNOPSIS

    use Chef::Knife::Cmd;

    my $knife = Chef::Knife::Cmd->new(
        verbose   => 0,           # if true, tee output to STDOUT; default is false
        logfile   => 'knife.log',
        print_cmd => 1,
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

    # All methods return the output of the cmd as a string
    my $out = $knife->node->show('mynode');
    # => 
    # Node Name:   mynode
    # Environment: production
    # FQDN:        
    # IP:          12.34.56.78
    # Run List:    ...
    # ...

    # All methods return the output of the cmd as a hashref when '--format json' is used
    my $hashref = $knife->node->show('mynode', format => 'json');
    # =>
    # {
    #     name             => "mynode",
    #     chef_environment => "production",
    #     run_list         => [...],
    #     ...
    # }


=head1 DESCRIPTION

This module is a small wrapper around the Chef 'knife' command line utility.

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

has verbose    => (is => 'rw', default => sub { 0 });
has print_cmd  => (is => 'rw', default => sub { 0 });
has noop       => (is => 'rw', default => sub { 0 });
has shell      => (is => 'lazy');
has logfile    => (is => 'ro');
has format     => (is => 'rw');
has _json_flag => (is => 'rw');

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
    my $shell = Shell::Carapace->new(
        print_cmd => $self->print_cmd(),
        verbose   => $self->verbose(),
        noop      => $self->noop(),
    );
    $shell->logfile($self->logfile) if $self->logfile();
    return $shell;
}

sub bootstrap {
    my ($self, $fqdn, %options) = @_;
    my @opts = $self->handle_options(%options);
    my @cmd  = (qw/knife bootstrap/, $fqdn, @opts);
    $self->run(@cmd);
}

sub handle_options {
    my ($self, %options) = @_;

    $options{format} //= $self->format if $self->format;

    $options{format} && $options{format} eq 'json'
        ? $self->_json_flag(1)
        : $self->_json_flag(0);

    my @opts;
    for my $option (sort keys %options) {
        my $value = $options{$option};
        $option =~ s/_/-/g;

        push @opts, "--$option";
        push @opts, $value if $value ne "1";
    }

    return @opts;
}

sub run {
    my ($self, @cmds) = @_;
    my $out = $self->shell->local(@cmds);
    return JSON->new->utf8->decode($out) if $self->_json_flag;
    return $out;
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
