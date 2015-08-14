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

    my $filter = new Serial::Core::FieldFilter($field, $values);
    $reader->filter($filter);


=head1 DESCRIPTION

A I<FieldFilter> is a callback that can be used with the C<filter()> method of 
a I<Reader> or I<Writer>. Field values are matched against a set of values, and
matching records can be whitelisted or blacklisted. 

=head2 CLASS METHODS

=over

=item new($field, $values, blacklist => 0)

Create a new I<FieldFilter> object.

=back

=head3 Required Positional Arguments

=over

=item I<field> 

The field name to match.

=item I<value>

An arrayref specifying the values to match against.

=back

=head3 Optional Named Arguments

=over

=item I<blacklist>

Specify if matching records will be whitelisted or blacklisted. Set this to a
true value to enable blacklisting.

=back

=head2 OBJECT METHODS

The object methods are used by I<Reader>s and I<Writer>s; there is no need to
access a I<FieldFilter> object directly.


=head1 EXPORTS

The I<Serial::Core> library makes this class available by default.

=cut
