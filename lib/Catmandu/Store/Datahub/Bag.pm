package Catmandu::Store::Datahub::Bag;

use Moo;
use Scalar::Util qw(reftype);
use LWP::UserAgent;
use Catmandu::Bag::IdGenerator::Datahub;
use Catmandu::Util qw(is_string require_package);

use Data::Dumper qw(Dumper);

with 'Catmandu::Bag';

has data_pid => (
    is => 'ro'
);

sub _build_id_generator {
    my ($self) = shift;
    my $data_pid = Catmandu::Bag::IdGenerator::Datahub->new(data_pid => $self->data_pid);
}

##
# before add in ::Bag creates a _id tag, which is useful for hashes and NoSQL-dbs, but breaks our
# XML conversion. You *can* remove it in your add/update function, but that feels unclean.
# You cannot use before add here to remove the _id, as this one is added before the before add
# from ::Bag (see http://search.cpan.org/~ether/Moose-2.1806/lib/Moose/Manual/MethodModifiers.pod).
# But around is called last. So we use it here.
around add => sub {
    my $orig = shift;
    my ($self, $data) = @_;
    if (reftype($data) eq reftype({})) {
        if (exists($data->{$self->store->key_for('id')})) {
            delete($data->{$self->store->key_for('id')});
        }
    }
    return $self->$orig($data);
};

around update => sub {
    my $orig = shift;
    my ($self, $id, $data) = @_;
    if (reftype($data) eq reftype({})) {
        if (exists($data->{$self->store->key_for('id')})) {
            delete($data->{$self->store->key_for('id')});
        }
    }
    return $self->$orig($id, $data);
};


sub generator {
    my ($self) = @_;
    # implementation-dependent
}

##
# Return a record identified by $id
sub get {
    my ($self, $id) = @_;
    my $url = sprintf('%s/%s', $self->store->url, $id);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->get($url, Authorization => sprintf('Bearer %s', $token));
    if ($response->is_success) {
        return $response->decoded_content;
    } else {
        print($response->status_line."\n");
        return undef;
    }
}

##
# Create a new record
sub add {
    my ($self, $data) = @_;
    my $url = sprintf('%s', $self->store->url);

    my $lido_data = $self->store->lido->to_xml($data);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->post($url, Content_Type => 'application/lido+xml', Authorization => sprintf('Bearer %s', $token), Content => $lido_data);
    if ($response->is_success) {
        return $response->decoded_content;
    } else {
        print($response->status_line."\n");
        return undef;
    }
}

##
# Update a record
sub update {
    my ($self, $id, $data) = @_;
    my $url = sprintf('%s/%s', $self->store->url, $id);

    my $lido_data = $self->store->lido->to_xml($data);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->put($url, Content_Type => 'application/lido+xml', Authorization => sprintf('Bearer %s', $token), Content => $lido_data);
    if ($response->is_success) {
        return $response->decoded_content;
    } else {
        print($response->status_line."\n");
        return undef;
    }
}

##
# Delete a record
sub delete {
    my ($self, $id) = @_;
    my $url = sprintf('%s/%s', $self->store->url, $id);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->delete($url, Authorization => sprintf('Bearer %s', $token));
    if ($response->is_success) {
        return $response->decoded_content;
    } else {
        print($response->status_line."\n");
        return undef;
    }
}

sub delete_all {}

1;