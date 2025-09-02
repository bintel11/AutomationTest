package MyMojoApp::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use JSON;
use File::Slurp;

my $data_file = 'data_store.json';

# Load data
sub load_data {
    return [] unless -e $data_file;
    my $json_text = read_file($data_file, err_mode => 'carp');
    return $json_text ? decode_json($json_text) : [];
}

# Save data
sub save_data {
    my ($data) = @_;
    write_file($data_file, encode_json($data));
}

# GET /protected/list
sub list {
    my $c = shift;
    $c->render(json => load_data());
}

# POST /protected/add
sub add {
    my $c = shift;
    my $name  = $c->param('name')  // '';
    my $email = $c->param('email') // '';

    return $c->render(text => 'Missing required field', status => 400)
        unless $name && $email;

    my $data = load_data();
    for my $item (@$data) {
        if ($item->{name} eq $name && $item->{email} eq $email) {
            return $c->render(text => "Record exists with ID $item->{id}", status => 409);
        }
    }

    my $new_id = 1 + (sort { $b <=> $a } map { $_->{id} } @$data)[0] // 0;
    push @$data, { id => $new_id, name => $name, email => $email };
    save_data($data);

    $c->render(text => "Added ID $new_id: $name ($email)");
}

# PUT /protected/update/:id
sub update {
    my $c = shift;
    my $id = $c->param('id');
    my $new_name  = $c->param('new_name')  // '';
    my $new_email = $c->param('new_email') // '';

    my $data = load_data();
    my $found = 0;

    for my $item (@$data) {
        if ($item->{id} == $id) {
            $item->{name}  = $new_name if $new_name;
            $item->{email} = $new_email if $new_email;
            $found = 1;
            last;
        }
    }

    if ($found) {
        save_data($data);
        $c->render(text => "Updated ID $id: $new_name ($new_email)");
    } else {
        $c->render(text => "ID $id not found", status => 404);
    }
}

# DELETE /protected/delete/:id
sub delete {
    my $c = shift;
    my $id = $c->param('id');

    my $data = load_data();
    my $removed = 0;

    for (my $i=0; $i<@$data; $i++) {
        if ($data->[$i]{id} == $id) {
            splice(@$data, $i, 1);
            $removed = 1;
            last;
        }
    }

    if ($removed) {
        save_data($data);
        $c->render(text => "Deleted item with ID: $id");
    } else {
        $c->render(text => "No item found with ID: $id", status => 404);
    }
}

1;
