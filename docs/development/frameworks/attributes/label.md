---
layout: docsPage
title: Label
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
            <td>textPlain</td>
            <td>string</td>
            <td>""</td>
            <td>Text to show on the label</td>
        </tr>
        <tr>
            <td>textCode</td>
            <td>string</td>
            <td>""</td>
            <td>Code that returns the text to show on the label</td>
        </tr>
    </tbody>
</table>

# Examples
```c++
class Label {
    condition = "true";
    type = "LABEL";
    textPlain = "This is some text!";
};
```
