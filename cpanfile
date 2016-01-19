## Perl dependencies for the Serial::Core module.
##
## Some package managers (e.g. cpanm and carton) can use this file to install
## requirements. Notably, however, cpanm will not install cpanfile dependencies
## recursively, i.e. if this is to be used as a dependency by another module,
## its dependencies need to be specified in a META.json file. One the other 
## hand, the META format only supports CPAN modules as dependencies, so Git 
## repo dependencies can only be given here. Thus, the two formats are not 
## mutually exclusive, and any Git dependencies listed here might also need to 
## be specified again in the cpanfile of any downstream module.
##

on develop => sub {
    # Provides `pod2rst` for generating ReST files for Sphinx. 
    suggests 'Pod::POM::View::Restructured', 0;
};
