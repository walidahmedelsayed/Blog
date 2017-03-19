package Blog::Controller::register;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('register') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::User'));
}

sub index :Chained('base') :PathPart("") :Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => "register.tt");
}

sub save :Chained('base') :PathPart("save") :Args(0) {
    my ($self, $c) = @_;

    my $name = $c->request->params->{name} || "";
    my $email = $c->request->params->{email} || "";
    my $password = $c->request->params->{password} || "";

    if ($name && $email && $password) {
        my $regex = $email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/;

        if($regex){
            my $user = $c->model('DB::User')->create({
                name => $name,
                email => $email,
                password => $password
            });

            $c->response->redirect($c->uri_for("/login"));
            return;
        }else{
            $c->flash->{error_msg} = "Invalid Email";

        }
    } else {
        $c->flash->{error_msg} = "Please Fill All The Fields";
    }
    $c->response->redirect($c->uri_for("/register"));
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
