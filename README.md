Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-barbican.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

barbican
========

#### Table of Contents

1. [Overview - What is the barbican module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with barbican](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Release Notes - Release notes for the project](#release-notes)
8. [Contributors - Those with commits](#contributors)
9. [Repository - The project source code repository](#repository)

Overview
--------

The barbican module is a part of [OpenStack](https://git.openstack.org), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module itself is used to flexibly configure and manage the Key management service for OpenStack.

Module Description
------------------

The barbican module is a thorough attempt to make Puppet capable of managing the entirety of barbican.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the barbican module to assist in manipulation of configuration files.

Setup
-----

**What the barbican module affects**

* [Barbican](https://wiki.openstack.org/wiki/Barbican), the Key management service for OpenStack.

### Installing barbican

barbican is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install barbican with:

```
puppet module install openstack/barbican
```

### Beginning with barbican

To utilize the barbican module's functionality you will need to declare multiple resources.  The following is a modified excerpt from the [openstack module](https://github.com/openstack/puppet-openstack).  This is not an exhaustive list of all the components needed, we recommend you consult and understand the [openstack module](https://github.com/openstack/puppet-openstack) and the [core openstack](http://docs.openstack.org) documentation.

Implementation
--------------

### barbican

barbican is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
-----------

* All the barbican types use the CLI tools and so need to be ran on the barbican node.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run the tests on the default vagrant node:

```shell
bundle install
bundle exec rake acceptance
```

For more information on writing and running beaker-rspec tests visit the documentation:

* https://github.com/puppetlabs/beaker-rspec/blob/master/README.md

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-barbican

Contributors
------------

* https://github.com/openstack/puppet-barbican/graphs/contributors

Repository
----------

* https://git.openstack.org/cgit/openstack/puppet-barbican

