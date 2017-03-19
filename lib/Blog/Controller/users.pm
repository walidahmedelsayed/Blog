package Blog::Controller::users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('users') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::User'));
}

sub list :Chained('base') :PathPart("list") :Args(0) {
    my ($self, $c) = @_;
    $c->stash(users => [$c->model('DB::User')->all()]);
    $c->stash(template => "list_users.tt");
}

sub delete :Chained('base') :PathPart('delete') :Args(1) {
    my ($self, $c ,$id) = @_;
if($id != 1){
    $c->stash->{resultset}->find($id)->delete;
    $c->response->redirect($c->uri_for($self->action_for("list")));
    }
    else {
            $c->flash->{error_msg} = "Sorry You Can't Delete The Admin";
            $c->response->redirect($c->uri_for($self->action_for("list")));
       }
 }



sub edit :Chained('base') :PathPart('edit') :Args(1) {
    my ($self, $c ,$id) = @_;

    my $user = $c->stash->{resultset}->find($id);
    $c->stash(user=>$user);
    $c->stash(template => "form_users.tt");
}

sub edit_profile :Chained('base') :PathPart('edit_profile') :Args(1) {
    my ($self, $c ,$id) = @_;

    my $user = $c->stash->{resultset}->find($id);
    $c->stash(user=>$user);
    $c->stash(template => "edit_profile.tt");
}

sub update :Chained('base') :PathPart('update') :Args(1) {
    my ($self, $c,$id) = @_;

    my $name =  $c->request->params->{name} || 'N/A';
    my $email =  $c->request->params->{email} || 'N/A';
    my $password = $c->request->params->{password} || 'N/A';

    $c->stash->{resultset}->find($id)->update({
            name => $name,
            email => $email,
            password => $password
    });
    $c->response->redirect($c->uri_for($self->action_for("list")));
}

sub update_profile :Chained('base') :PathPart('update_profile') :Args(1) {
    my ($self, $c,$id) = @_;

    my $name =  $c->request->params->{name} || 'N/A';
    my $email =  $c->request->params->{email} || 'N/A';
    my $password = $c->request->params->{password} || 'N/A';

    $c->stash->{resultset}->find($id)->update({
            name => $name,
            email => $email,
            password => $password
    });
    $c->response->redirect($c->uri_for("/posts/list"));
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
