sysedge Cookbook
================
This cookbook deploys sysedge for the following platform familly:
    debian-ish
    redhat-ish


Requirements
------------

External Internet Access

#### packages
TODO: Will need to revisit when this is cookbook is finished

Attributes
----------

#### sysedge::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sysedge']['trapCommunity']</tt></td>
    <td>String</td>
    <td>SNMP Trap Community String</td>
    <td><tt>public</tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['communityType']</tt></td>
    <td>String</td>
    <td>SNMP Community Read/write Level</td>
    <td><tt>read</tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['syscontact']</tt></td>
    <td>String</td>
    <td>System Contact Information for Spectrum</td>
    <td><tt>wse@rackspace.com</tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['dataDirectory']</tt></td>
    <td>String</td>
    <td>Configuration Directory for SystemEDGE</td>
    <td><tt>/opt/CA/SystemEDGE/config</tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['port']</tt></td>
    <td>String</td>
    <td>UDP Listen Port for SystemEDGE</td>
    <td><tt>1691</tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['trapSource']</tt></td>
    <td>String</td>
    <td>Public IP Address of the Server</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['community']</tt></td>
    <td>String</td>
    <td>SNMP Community String</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['sysdescr']</tt></td>
    <td>String</td>
    <td>Server Hostname</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['syslocation']</tt></td>
    <td>String</td>
    <td>Server Datacenter</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['sysedge']['trapCommunityDest']</tt></td>
    <td>String</td>
    <td>SNMP Trap Destination IP</td>
    <td><tt></tt></td>
  </tr>
</table>

#### sysedge::redhat
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sysedge']['redhat']['src_url']</tt></td>
    <td>String</td>
    <td>Source URL for SystemEDGE Installer</td>
    <td><tt></tt></td>
  </tr>
</table>

Usage
-----
#### sysedge::default

Just include `sysedge` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sysedge]"
  ]
}
```

License and Authors
-------------------
Authors: Victor Palma
Authors: Derek Lane
Authors: Josh Mattson
Authors: Dustin Randel
Authors: Jake Briggs

