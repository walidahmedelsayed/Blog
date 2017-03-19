package Blog::Controller::login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('login') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::User'));
}

sub index :Chained('base') :PathPart("") :Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => "login.tt");
}

sub submit :Chained('base') :PathPart("submit") :Args(0) {
    my ($self, $c) = @_;

    my $email = $c->request->params->{email};
    my $password = $c->request->params->{password};

    if ($email && $password) {
        if ($c->authenticate({ email => $email,password => $password } )) {
            $c->response->redirect($c->uri_for("/"));
            return;
        } else {
            $c->flash->{error_msg} = "Wrong Username Or Password";
        }
    } else {
        $c->flash->{error_msg} = "Please Fill All The Fields";
    }
    $c->response->redirect($c->uri_for($c->controller('posts')->action_for("list")));
}




=encoding utf8

=head1 AUTHOR

walid,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
