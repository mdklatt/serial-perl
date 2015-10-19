use 5.008;
use strict;
use warnings;

use Module::Build;


my $class = Module::Build->subclass(code => q(
    # Subclass Module::Build to add a `librst` command that will generate
    # reStructuredText files from the project's POD documentation.   
    
    use strict;
    use warnings;
    
    use File::Find;
    use Pod::POM;
    use Pod::POM::View::Restructured;
    
    our $parser = Pod::POM->new();
    our $docroot = 'doc';  # TODO: get from project configuration 
    
    sub make_rst {
        # Callback for find() to convert any POD in a file to an .rst file.
        # The POD can be a regular Perl file or a separate .pod file, but
        # not both (e.g. if Foo.pod exists, Foo.pm should not contain any
        # POD).
        return if -d $_;
        my $pom = $parser->parse_file($_);
        return if not @{$pom->content()};
        my $rst = $pom->present(new Pod::POM::View::Restructured->new());
        my $rst_path = $_;
        $rst_path =~ s/$File::Find::dir/$docroot/;  # path
        $rst_path =~ s/\.[^\.]*$/.rst/;  # file extension
        open my $stream, '>', $rst_path;
        print $stream $rst;
        close $stream;
        print "Documentation written to $rst_path\n";
    }
    
    sub ACTION_librst {
        find({wanted => \&make_rst, no_chdir => 1}, 'lib/');
    }
));


my $builder = $class->new(
    module_name         => 'Serial::Core',
    license             => 'perl',
    dist_author         => q(Michael Klatt <mdklatt@ou.edu>),
    dist_version_from   => 'lib/Serial/Core.pm',
    release_status      => 'unstable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => ['Serial-Core-*'],
    create_makefile_pl => 'traditional',
);


$builder->create_build_script();
