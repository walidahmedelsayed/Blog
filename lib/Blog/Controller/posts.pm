package Blog::Controller::posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('posts') :CaptureArgs(0) {
    my ($self, $c) = @_;
    if($c->user_exists()){
    $c->stash(resultset => $c->model('DB::Post'));}
    else {
      $c->response->redirect($c->uri_for("/login"));
    }
}

sub list :Chained('base') :PathPart("list") :Args(0) {
    my ($self, $c) = @_;

    $c->stash(posts => [$c->model('DB::Post')->search({},{ order_by => 'id DESC' })]);
    $c->stash(comments => [$c->model('DB::Comment')->all()]);
    $c->stash(users => [$c->model('DB::User')->all()]);
    $c->stash(template => "list.tt");
}

sub create_post :Chained('base') :PathPart('create_post') :Args(0) {
    my ($self, $c) = @_;

    my $title = $c->request->params->{title} || "";
    my $content = $c->request->params->{content} || "";

    if ($title && $content) {
        my $post = $c->model('DB::Post')->create({
                title => $title,
                content => $content,
                user_id => $c->user->id
            });

        $c->response->redirect($c->uri_for("/posts/list"));
        return;
    } else {
        $c->flash->{error_msg} = "Empty Title Or Content";
    }

    $c->response->redirect($c->uri_for($self->action_for("list")));
}

sub delete :Chained('base') :PathPart('delete') :Args(1) {
    my ($self, $c ,$id) = @_;

    $c->stash->{resultset}->find($id)->delete;
    $c->response->redirect($c->uri_for($self->action_for("list")));
}

sub edit :Chained('base') :PathPart('edit') :Args(1) {
    my ($self, $c ,$id) = @_;

    my $post = $c->stash->{resultset}->find($id);
    $c->stash(post=>$post);
    $c->stash(template => "form.tt");
}

sub update :Chained('base') :PathPart('update') :Args(1) {
    my ($self, $c,$id) = @_;

    my $title = $c->request->params->{title} || 'N/A';
    my $content = $c->request->params->{content} || 'N/A';

    $c->stash->{resultset}->find($id)->update({
            title => $title,
            content => $content,
    });
    $c->response->redirect($c->uri_for($self->action_for("list")));
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
