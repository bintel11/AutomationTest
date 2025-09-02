package MyMojoApp;
use Mojo::Base 'Mojolicious', -signatures;

# In-memory "DB"
my $data = {};
my $next_id = 1;

sub startup ($self) {

    # Root route
    $self->routes->get('/' => sub ($c) {
        $c->render(text => 'Welcome to the Mojo App!');
    });

    # --------------------------
    # POST /add
    # --------------------------
    $self->routes->post('/add' => sub ($c) {
        my $name  = $c->param('name');
        my $email = $c->param('email');

        # Validation checks
        return $c->render(text => "Missing required field: name", status => 400)
            unless $name;
        return $c->render(text => "Missing required field: email", status => 400)
            unless $email;
        return $c->render(text => "Invalid email format", status => 400)
            unless $email =~ /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        # Prevent duplicates
        foreach my $id (keys %$data) {
            if ($data->{$id}{name} eq $name && $data->{$id}{email} eq $email) {
                return $c->render(
                    text   => "Record already exists with ID $id: $name ($email)",
                    status => 409
                );
            }
        }

        # Insert new record
        my $id = $next_id++;
        $data->{$id} = { id => $id, name => $name, email => $email };
        $c->render(text => "Added ID $id: $name ($email)", status => 200);
    });

    # --------------------------
    # PUT /update/:id
    # --------------------------
    $self->routes->put('/update/:id' => sub ($c) {
        my $id       = $c->param('id');
        my $new_name = $c->param('new_name');
        my $new_email = $c->param('new_email');

        # Validation
        return $c->render(text => "Invalid update data", status => 400)
            unless $new_name && $new_email;
        return $c->render(text => "Invalid email format", status => 400)
            unless $new_email =~ /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        # Not found
        return $c->render(text => "No item found with ID: $id", status => 404)
            unless exists $data->{$id};

        # Update
        $data->{$id} = { id => $id, name => $new_name, email => $new_email };
        $c->render(text => "Updated ID $id: $new_name ($new_email)", status => 200);
    });

    # --------------------------
    # DELETE /delete/:id
    # --------------------------
    $self->routes->delete('/delete/:id' => sub ($c) {
        my $id = $c->param('id');
        if (delete $data->{$id}) {
            $c->render(text => "Deleted item with ID: $id", status => 200);
        } else {
            $c->render(text => "No item found with ID: $id", status => 404);
        }
    });

    # --------------------------
    # GET /list
    # --------------------------
    $self->routes->get('/list' => sub ($c) {
        my @records = values %$data;
        $c->render(json => \@records);
    });

    # --------------------------
    # Catch-all for unknown routes
    # --------------------------
    $self->routes->any('/*whatever' => sub ($c) {
        $c->render(text => 'Not found', status => 404);
    });
}

1;
