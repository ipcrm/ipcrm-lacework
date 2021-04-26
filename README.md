# Lacework Agent

## Table of Contents

1. [Description](#description)
1. [Beginning with lacework](#beginning-with-lacework)
    * [Setup requirements](#setup-requirements)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The Lacework module enables you to install and configure the agent onto target systems.  Learn more about Lacework agent
installation [here](https://support.lacework.com/hc/en-us/articles/1500007191502-Agent-Installation-Prerequisites).

### Beginning with the Lacework module

The simplest usage of this module is simply to declare the class including your access token:

```puppet
class{ 'lacework':
  access_token =>  "<your token here>"
}
```

See the module reference for a full listing and description of the available parameters.


### What lacework affects

With default options, the Lacework agent module will add package repositories, install the Lacework agent package,
manage the configuration file, and manage the agent service. Review the module reference for details on modifying this
behavior.

### Setup Requirements

For Debian based systems, the `lsb_release` command must be installed for this module to automatically setup apt repos
properly.

## Development

This module is PDK compatible and was designed to use `puppet_litmus` for acceptance testing.  As such, some Lacework
agent supported operating systems cannot be tested automatically via the acceptance testing (no images are available).
