[![Build Status](https://travis-ci.org/kablamo/p5-chef-knife-cmd.svg?branch=master)](https://travis-ci.org/kablamo/p5-chef-knife-cmd) [![Coverage Status](https://img.shields.io/coveralls/kablamo/p5-chef-knife-cmd/master.svg)](https://coveralls.io/r/kablamo/p5-chef-knife-cmd?branch=master)
# NAME

Chef::Knife::Cmd - A small wrapper around the Chef 'knife' command line utility

# SYNOPSIS

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

# DESCRIPTION

This module is a small wrapper around the Chef 'knife' command line utility.
It would be awesome if this module used the Chef server API, but this module is
not that awesome.

Some things worth knowing about this module:

- Return vaules

    All commands return the output of the knife command.  

- Logging

    All knife cmd output is logged to a logfile for later analysis.  This allows
    you to provide verbose logging to users while not cluttering their terminal
    with tons of output.

- Tee output to STDOUT

    Instead of waiting for an hour for a knife command to finish, you can view
    output from the knife command in real time as it happens.  This happens when
    the 'verbose' attribute is true.

- Exceptions

    If a knife command fails, this module will throw an exception.

# SEE ALSO

- Capture::Tiny::Extended
- Capture::Tiny
- IPC::System::Simple

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Eric Johnson <eric.git@iijo.org>
