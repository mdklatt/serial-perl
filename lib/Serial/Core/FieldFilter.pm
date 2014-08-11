package Serial::Core::FieldFilter;
use base qw(Serial::Core::_RecordFilter);
use strict;
use warnings;

# Initialize this object.
#
# A FieldFilter is initialized with a field, an array of values, and an
# optional 'blacklist' keyword argument that controls if this is a blacklist
# or a whitelist (default is whitelist).
#
sub _init {
    # This is called by new() to do the real work when an object is created.
    # Derived classes may override this as necessary.
    my $self = shift @_;
    my ($field, $values, %opts) = @_;
    $self->SUPER::_init($field, %opts);
    $self->{_values} = {map { $_ => 1 } @$values};  # pseudo set
    return;
}

sub _match {
    my $self = shift @_;
    my ($value) = @_;
    return $self->{_values}{$value};
}

1;

__END__

=pod 

=encoding utf8

=head1 NAME

Serial::Core::FieldFilter - filter records using a set of values

=head1 SYNOPSIS

    use Serial::Core;

    $whitelist = new Serial::Core::FieldFilter($field, $values);
    $reader->filter($whitelist);

=head1 DESCRIPTION

A I<FieldFilter> is intended for use with the C<filter()> method of a I<Reader>
or I<Writer>. The given field is matched against a set of values. Matching 
records can be whitelisted or blacklisted.

=head2 CLASS METHODS

=over

=item new($field, $range, blacklist => 0)

Create a new filter. The first argument is the name of the field to match. The
next argument is an arrayref of values. Set the optional named boolean argument 
I<blacklist> to true for blacklisting; whitelisting is the default behavior.

=back

=head2 OBJECT METHODS

The object interface is used by I<Reader>s and I<Writer>s; there is no need to
use a I<FieldFilter> object directly in user code.

=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
