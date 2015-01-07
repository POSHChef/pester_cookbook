Pester Cookbook
===============

Adds the Pester PowerShell module, via Chocolatey, to a machine and then configures a test handler.  This is so that the machine can be tested after POSHChef has completed its run.

Requirements
------------
This cookbook depends on the following cookbooks

- `Chocolatey` - Pester needs the cookbook `Chocolatey` to install itself

Attributes
----------
The following are the Pester attributes.

+ node['Pester']['version'] - Version of Pester that should be installed.  Default: **3.1.1**

The default chocolatey recipe needs to be told that it has to install Pester.  The following JSON will accomplish this.

```JSON
{
  "Chocolatey": {
    "Packages": {
      "Pester": {
        "windows_display_name": ""
      }
    }
  }
}
```
It is the keys of the 'Pester' hashtable that are used by chocolatey to determine what packages needs to be installed.

The optional ```windows_display_name``` is to assist the Chocolatey DSC resource in working out if the application has already been installed by different means.  It will check the registry for this value and if the attributes have been set appropriately will not install it again if the it found.

Please refer to the Chocolatey cookbook for more information.

Usage
-----
#### Pester::default
Writes out the ```pester-handler.ps1``` file from the cookbook to the test handler directory for POSHChef.  By default this will be ```C:\POSHChef\handlers\test```.  It is this file that POSHChef will run when it executes tests.

The role that would install Pester and then run the tests would be as follows:

```json
{
  "name":"Pester",
  "default_attributes": {
    "Tests": {
      "enabled": true
    }
  }
  "run_list": [
    "recipe[Chocolatey]",
    "recipe[Pester]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like dd_component_x)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Russell Seymour (<russell.seymour@turtlesystemsconsulting.co.uk>)

```text
Copyright:: 2010-2014, Turtlesystems Consulting, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
