package Blog::Controller::comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('comments') :CaptureArgs(0) {
    my ($self, $c) = @_;
    if($c->user_exists()){
    $c->stash(resultset => $c->model('DB::Comment'));}
    else {
      $c->response->redirect($c->uri_for("/login"));
    }
}

sub create_comment :Chained('base') :PathPart('create_comment') :Args(0) {
    my ($self, $c) = @_;

    my $comment = $c->request->params->{comment} || "";
    my $post_id = $c->request->params->{post_id} || "";
    my $user_id = $c->request->params->{user_id} || "";

    if ($comment) {
        my $com = $c->model('DB::Comment')->create({
                comment => $comment,
                post_id =>$post_id,
                user_id =>$user_id

            });

        $c->response->redirect($c->uri_for("/posts/list"));
        return;
    } else {
        $c->flash->{error_msg} = "Empty Comment";
    }

    $c->response->redirect($c->uri_for($c->controller('posts')->action_for("list")));
}

sub delete :Chained('base') :PathPart('delete') :Args(1) {
    my ($self, $c ,$id) = @_;

    $c->stash->{resultset}->find($id)->delete;
   $c->response->redirect($c->uri_for($c->controller('posts')->action_for("list")));
}

sub edit :Chained('base') :PathPart('edit') :Args(1) {
    my ($self, $c ,$id) = @_;

    my $comment = $c->stash->{resultset}->find($id);
    $c->stash(comment=>$comment);
    $c->stash(template => "comment_form.tt");
}

sub update :Chained('base') :PathPart('update') :Args(1) {
    my ($self, $c,$id) = @_;

    my $comment = $c->request->params->{comment} || 'N/A';


    $c->stash->{resultset}->find($id)->update({
            comment => $comment

    });
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
