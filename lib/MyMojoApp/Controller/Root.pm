package MyMojoApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

# Root route
sub index {
    my $self = shift;
    $self->render(template => 'index');
}

1;