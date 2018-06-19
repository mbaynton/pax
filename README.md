#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with pax](#setup)
    * [What pax affects](#what-pax-affects)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Description

A hiera-powered approach to software and repository management for Puppet

pax provides an abstraction layer to software and repository management that allows users to simply request a command or package be provided and let Puppet deal with configuring the required repositories and installing the correct packages.

## Setup

### What pax affects

By default, pax will automatically configure any required repositories and repository GPG keys to provide the requested command or package. This can be controlled with the [manage_repos](#manage_repos) and [manage_repo_trust](#manage_repo_trust) parameters.

## Usage

Configure repositories and install packages required for the command git:

    $package_ref = pax::cmd('git')

Configure required repositories and install the package git:

    $package_ref = pax::package('git')

Ensure git is installed before calling it:

    exec { 'git version':
      command => '/usr/bin/git --version',
      require => pax::cmd('git'),
    }

pax can be configured not to manage repositories and repository trusts by declaring the pax class before calling any pax functions:

    class { 'pax':
      manage_repos      => false,
      manage_repo_trust => false,
    }

### Adding data to paxdb

pax is configured to get all of its repository, package and command data from Hiera. Check out [hiera.yaml](hiera.yaml) for the current hierarchy.

#### Adding a repository GPG key

```YAML
pax::repotrust:
  RPM-GPG-KEY-SHIBBOLETH-7:
    resource: pax::repo_helpers::rpm_gpg_key
    params:
      file: /etc/pki/rpm-gpg/RPM-GPG-KEY-SHIBBOLETH-7
      content: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        ...
        -----END PGP PUBLIC KEY BLOCK-----
```

#### Adding a repository

```YAML
pax::repo:
  shibboleth:
    resource: yumrepo
    params:
      enabled: true
      enable_baseurl: false
      mirrorlist: https://shibboleth.net/cgi-bin/mirrorlist.cgi/CentOS_7
      descr: Shibboleth for Enterprise Linux
      gpgcheck: 1
      gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-%{::pax::repo_helpers::el::releasever}
    repotrust: RPM-GPG-KEY-SHIBBOLETH-%{::pax::repo_helpers::el::releasever}
```

#### Adding a package

```YAML
pax::package:
  shibboleth.x86_64:
    repo: shibboleth
```

#### Adding a command

```YAML
pax::cmd-package:
  shibboleth-sp: shibboleth.x86_64
```

## Reference

### Class: pax

Base class that configures whether to manage repositories and repository GPG keys. Including or declaring this class is not required if the defaults are acceptable.

#### Parameters

##### [*manage_repos*]
Whether pax should manage system repositories. Default: *true*

##### [*manage_repo_trust*]
Whether pax should manage repository GPG keys. Default: *true*

### Function: pax::cmd

Function used to install a command or other piece of
software by its pax canonical name. For software commonly
run from the command line whose name is consistent from
distribution to ditribution (things like awk), its pax
canonical name should be what you expect.

Internally, the pax database translates the cmd name to
the name of the package that contains that command on your
operating system, and installs that package. As a result,
using this function in your manifests is, to the extent
the pax database has knowledge, OS independent.

#### Parameters

##### [*name*]
The name of the command or software to install.

###### Return
An array of Resource types that were added to the manifest as a result
of calling this function.
You can use this, for example, in require => metaparameters.

### Function: pax::package

Function used to install a package by the name known to your OS's
package manager.

#### Parameters

##### [*name*]
The name of the package to install.

###### Return
An array of Resource types that were added to the manifest as a result
of calling this function.
You can use this, for example, in require => metaparameters.

### Function: pax::repo

Function used to configure a repository.

#### Parameters

##### [*name*]
The name of the repository to configure.

###### Return

An OS-specific repository resource. (Currently only yumrepo)

## Limitations

pax has a limited command/package/repository database included and currently only has built-in support for CentOS/RHEL 5 and 7.
