package MT::Plugin::DataAPIForceLogin;
use strict;
use warnings;
use base qw( MT::Plugin );

my $plugin = __PACKAGE__->new(
    {   name    => 'DataAPIForceLogin',
        version => 0.01,
        plugin_link =>
            'https://github.com/masiuchi/mt-plugin-data-api-force-login',
        description =>
            '<__trans phrase="Force all endpoints of Data API to login.">',

        author_name => 'masiuchi',
        author_link => 'https://github.com/masiuchi',

        registry => { callbacks => { init_app => \&_init_app, }, },
    }
);
MT->add_plugin($plugin);

sub _init_app {
    require MT::App::DataAPI;
    my $_compile_endpoints = \&MT::App::DataAPI::_compile_endpoints;
    no warnings 'redefine';
    *MT::App::DataAPI::_compile_endpoints = sub {
        my $ret = $_compile_endpoints->(@_);
        for my $ep ( @{ $ret->{list} } ) {
            $ep->{requires_login} = 1;
        }
        return $ret;
    };
}

1;
