---
layout: docsPage
title: Menu Strip
group: development
order: 2
---

# Overview
The menu strip appears at the top of the Mars interface and hosts context menus. It is used for when you want to do something that doesn't necessarily require a position or object selection. An example of this would be an 'End Scenario' option that would open an attributes window.

# Usage
All menus should be defined in a `CfgMenu.hpp` file, included in the `config.cpp`. Below you will find an example config.

```c++
class GVARMAIN(menu) {
    class ADDON {
        class settings {
            displayName = "Settings";
            class camera {
                displayName = "Camera";
                action = QUOTE([ARR_2(QUOTE(QUOTE(ADDON)), 'settings_camera')] call EFUNC(attributes,openAttributes));
            };
        };
    };
};
```

**Note: Menus can only be one level deep (as shown above) - recursive menus are planned for the future.**


# Attributes
<table>
    <thead>
        <tr>
            <th>Attribute</th>
            <th>Type</th>
            <th>Optional</th>
            <th>Default</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>displayName</td>
            <td>string</td>
            <td>no</td>
            <td>""</td>
            <td>Text to show to the end user in the menu</td>
        </tr>
        <tr>
            <td>action</td>
            <td>string</td>
            <td>no</td>
            <td>""</td>
            <td>Code to execute upon clicking the menu</td>
        </tr>
    </tbody>
</table>
