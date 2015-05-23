requires 'Moo';
requires 'Shell::Carapace', '>=0.03';
requires 'String::ShellQuote';
requires 'JSON::MaybeXS';

on 'test' => sub {
    requires 'Test::Most';
};

on 'develop' => sub {
    requires 'Minilla';
}

