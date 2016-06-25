---
layout: docsPage
title: Vector
---

# Properties

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Default</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>condition</td>
            <td>string</td>
            <td>"true"</td>
            <td>Condition that must return true to show the control. Arguments passed to the condition are <code>[selection&lt;ARRAY&gt;]</code></td>
        </tr>
        <tr>
            <td>value</td>
            <td>array/string</td>
            <td>[]</td>
            <td>Array containing three numeric values for the vector (X, Y, Z). If string is provided, it will be compiled and must return an array</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the value of the control changes</td>
        </tr>
    </tbody>
</table>

# Examples
```c++
class Vector1 {
    condition = "true";
    type = "VECTOR";
    value[] = {0, 0, 0};
};

class Vector2 {
    condition = "true";
    type = "VECTOR";
    value = "getPos player";
};
```
