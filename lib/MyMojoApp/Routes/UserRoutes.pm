package MyMojoApp::Routes::UserRoutes;
use Mojo::Base 'Mojolicious::Controller';
use MyMojoApp::Controller::User;

sub register {
    my ($app) = @_;

    # All protected routes under /protected
    my $r = $app->routes->under('/protected');

    $r->get('/list')->to(cb => \&MyMojoApp::Controller::User::list);
    $r->post('/add')->to(cb => \&MyMojoApp::Controller::User::add);
    $r->put('/update/:id')->to(cb => \&MyMojoApp::Controller::User::update);
    $r->delete('/delete/:id')->to(cb => \&MyMojoApp::Controller::User::delete);
}

1;
