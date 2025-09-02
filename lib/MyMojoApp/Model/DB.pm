package MyMojoApp::Model::DB;
use Mojo::Base -base;
use DBIx::Class::Schema;

# Database schema
sub schema {
    my $self = shift;
    return $self->{schema} ||= MyMojoApp::Schema->connect('dbi:SQLite:dbname=mojo_app.db');
}

1;
