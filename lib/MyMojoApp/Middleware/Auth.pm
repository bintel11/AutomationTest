package MyMojoApp::Middleware::Auth;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';

# Plugin to register auth hook
sub register {
    my ($self, $app, $conf) = @_;

    # before_dispatch hook runs before every request
    $app->hook(before_dispatch => sub {
        my $c = shift;

        # Only protect /protected routes
        return unless $c->req->url->path->starts_with('/protected');

        # Check Authorization header
        my $auth = $c->req->headers->header('Authorization') // '';
        if ($auth eq 'Bearer mysecrettoken') {
            return 1; # authorized, continue
        }

        $c->render(text => 'Unauthorized', status => 401);
        $c->rendered; # halt further processing
    });
}

1; # must return true
