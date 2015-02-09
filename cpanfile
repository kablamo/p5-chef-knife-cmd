requires 'Moo';
requires 'Shell::Carapace';
requires 'String::ShellQuote';
requires 'JSON::MaybeXS';

on 'test' => sub {
    requires 'Test::Most';
};

on 'build' => sub {
    requires 'Minilla';
}

