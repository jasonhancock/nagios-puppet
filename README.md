# nagios-puppet

A collection of Nagios scripts/plugins for monitoring Puppet stuff.


## License

See the [LICENSE](LICENSE.md) file

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

If the dashboard is running on a port other than port 80, adjust the -p
parameter in the command. If your dashboard is behind ssl, add the -s option.
If you are using HTTP basic authentication, see the -U, -P and -r options.

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
