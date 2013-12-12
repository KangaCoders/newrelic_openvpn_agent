## New Relic OpenVPN monitoring Plugin

The New Relic OpenVPN Plugin enables monitoring OpenVPN, and it reports the following data:

* Amount of active Users
* Amount of active Clients
* Amount of bytes sent
* Amount of bytes received
* Average of bytes sent
* Average of bytes received

### Requirements

The OpenVPN monitoring Plugin for New Relic requires the following:

* A New Relic account. Signup for a free account at http://newrelic.com
* You need a host to install the plugin on the OpenVPN server. That host also needs Ruby (tested with 1.8.7, 1.9.3), and support for rubygems.

### Instructions for running the OpenVPN agent

1. Install this gem from RubyGems:

    `sudo gem install newrelic_openvpn_agent`

2. Install config, execute

    `sudo newrelic_openvpn_agent install` - it will create `/etc/newrelic/newrelic_openvpn_agent.yml` file for you.

3. Edit the `/etc/newrelic/newrelic_openvpn_agent.yml` file generated in step 2. 
 
    3.1. replace `YOUR_LICENSE_KEY_HERE` with your New Relic license key. Your license key can be found under Account Settings at https://rpm.newrelic.com, see https://newrelic.com/docs/subscriptions/license-key for more help.

    3.2. replace the agent name 'openvpn' to any unique instance name of choice

    3.3. replace the path of the OpenVPN status binary if needed

4. Execute

    `newrelic_openvpn_agent run`
  
5. Go back to the Plugins list and after a brief period you will see the OpenVPN Plugin listed in your New Relic account


## Keep this process running

You can use services like these to manage this process and run it as a daemon.

- [Upstart](http://upstart.ubuntu.com/)
- [Systemd](http://www.freedesktop.org/wiki/Software/systemd/)
- [Runit](http://smarden.org/runit/)
- [Monit](http://mmonit.com/monit/)

## Support

Please use Github issues for support.