nagios-puppet
=============

A collection of Nagios scripts/plugins for monitoring Puppet stuff.


License
-------
Copyright (c) 2012 Jason Hancock <jsnbyh@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

PLUGINS:
-------
**check_pupdash_nodes:**

This check is designed to be run against a host that is running the puppet
dashboard application. The plugin grabs the index page of the application
and parses the results, generating a graph of machines based on their current
state:

![check_pupdash_nodes](https://github.com/jasonhancock/nagios-puppet/raw/master/example-images/check_pupdash_nodes.png)

Assuming that your host running the dashboard app is in a hostgroup called
'Puppet Dashboard', an example configuration might resemble this:

```
define command{
    command_name check_pupdash_nodes
    command_line $USER1$/check_pupdash_nodes -H $HOSTADDRESS$ -p 80
}

define service{
    use                  generic-service-graphed
    service_description  Puppet Dashboard Nodes
    hostgroups           Puppet Dashboard
    check_command        check_pupdash_nodes
}
```

If you have authentication in front of the dashboard, you will have to modify the
script to accept a username/password. If the dashboard is running on a port other
than port 80, adjust the -p parameter in the command.

**check_puppet_comptime:**

This check is designed to be run locally on the puppetmaster via NRPE and returns
the average catalog compilation time based on the puppetmaster's log.

Example NRPE configuration:

```
command[check_puppet_comptime]=/usr/bin/sudo /usr/lib64/nagios/plugins/check_puppet_comptime -w 2 -c 3 -f /var/log/messages
```

Note that because the script is parsing the syslog, you need root access. If you are
logging to some other file, then this may not be necessary. To enable nrpe to run 
this plugin as root, I added the following to my sudoers file:

```
Cmnd_Alias PUPPET = /usr/lib64/nagios/plugins/check_puppet_comptime *
nrpe  ALL=(ALL)       NOPASSWD: PUPPET
```

You may also need to comment out `Defaults requiretty` in your sudoers file".
Once you have the NRPE config working, configure the nagios side of things just like you
would for any other NRPE check.
