package MyMojoApp::Schema::Result::User;
use strict;
use warnings;
use base 'DBIx::Class::Core';

# Table name
__PACKAGE__->table('users');

# Columns
__PACKAGE__->add_columns(
    id       => { data_type => 'INTEGER', is_auto_increment => 1 },
    username => { data_type => 'VARCHAR', size => 255 },
    email    => { data_type => 'VARCHAR', size => 255 },
);

# Primary key
__PACKAGE__->set_primary_key('id');

1;
