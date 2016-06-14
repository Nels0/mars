---
layout: docsPage
title: Attributes
group: development
order: 5
---

# What is the attributes framework?
The attributes framework is quite simply a set of code that handles the UI stuff for you. This means you don't have to spend dozens of hours making your own UI dialog just to set some values. Instead you just write a simple attributes config and call the function to open it.

# Why do I have to use it?
A consistent UI design throughout Mars is a main priority and in order to achieve this, _almost_ all dialogs must be created using the attributes framework. Not only that but it centralises the UI code into a single component, as appose to multiple components all doing their own thing when it comes to UI.

# How do I use it?
1. Add a `CfgAttributes.hpp` file to your component's root folder
2. Place the following config in the file
3. Include `CfgAttributes.hpp` in your `config.cpp` **after** the `script_component.hpp` include
4. Go through the various control types available in the sidebar
5. When you're ready to use your attributes class, just call it using `[QUOTE(ADDON), "YourAttributeName"] call mars_attributes_fnc_openAttributes`

```c++
class GVARMAIN(attributes) {
    class ADDON {
        class YourAttributeName {
            displayName = "";
            actionConfirm = "";
            actionCancel = "";
            class AttributeCategories {
                class YourCategoryOne {
                    class AttributeItems {
                        class YourItemOne {
                            displayName = "";
                            tooltipText = "";
                            class AttributeControls {
                                class YourControlOne {};
                            };
                        };
                    };
                };
            };
        };
    };
};
```

A more fuller example can be found [here](https://github.com/jameslkingsley/Mars/blob/master/addons/environment/CfgAttributes.hpp).

## Identifiers
Identifiers will allow you to return a control from another part of your attribute config. An example usage would be to have a combo box populated with all groups in the mission, and then an edit box with the group ID of the selected group. When you change the combo box, ideally you want it to change the value of the edit box. See below for an example.

```c++
class GVARMAIN(attributes) {
    class ADDON {
        class groups {
            displayName = "Group Management";
            actionConfirm = "";
            actionCancel = "";
            class AttributeCategories {
                class Basics {
                    class AttributeItems {
                        class Select {
                            displayName = "Group";
                            tooltipText = "Select the group to edit.";
                            class AttributeControls {
                                class List {
                                    condition = "true";
                                    identifier = "GroupList";
                                    type = "COMBO";
                                    labels = QUOTE(\
                                        (allGroups select {\
                                            {!isPlayer _x} count (units _x) == 0\
                                        }) apply {format [ARR_3('%1 (%2)', groupID _x, name leader _x)]}\
                                    );
                                    values = QUOTE(\
                                        (allGroups select {\
                                            {!isPlayer _x} count (units _x) == 0\
                                        }) apply {getPlayerUID (leader _x)}\
                                    );
                                    selected = QUOTE(getPlayerUID (leader player));
                                    expression = "";
                                };
                            };
                        };
                        class Name {
                            displayName = "Name";
                            tooltipText = "The name of the group appears on its map marker.";
                            class AttributeControls {
                                class Name {
                                    condition = "true";
                                    type = "EDIT";
                                    textCode = QUOTE(\
                                        private _groupCtrl = ['GroupList'] call mars_attributes_fnc_getControl;\
                                        private _leaderUID = _groupCtrl lbData (lbCurSel _groupCtrl);\
                                        private _group = (allGroups select {getPlayerUID (leader _x) == _leaderUID}) select 0;\
                                        groupID _group\
                                    );
                                    expression = "";
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};
```

## Control values
This only applies to the `actionConfirm` property. If you want the user to fill out a form with some data and then process it all at once in one place then you would call a function in `actionConfirm`. From there you can get the value of each control by doing the following:

```c++
class GVARMAIN(attributes) {
    class ADDON {
        class Example {
            displayName = "Example";
            actionConfirm = QUOTE(\
                _myControl = [_this, 'MyCategory_MyItem_MyControl'] call mars_attributes_fnc_getControlValue;\
                systemChat str _myControl;\
            );
            class AttributeCategories {
                class MyCategory {
                    class AttributeItems {
                        class MyItem {
                            class AttributeControls {
                                class MyControl {};
                            };
                        };
                    };
                };
            };
        };
    };
};
```

The string represents the control key (generated for every control) which is simply the category class name, item class name and control class name joined by underscores. This allows you to reorder your attribute config and not worry about parameter order.

## Window Size
You can change the size of the overall window by simply providing another parameter to `openAttributes` such as `[QUOTE(ADDON), "YourAttributeName", [75, 50]] call mars_attributes_fnc_openAttributes`. The first element in the array is the width, the second is the height.

## Label and field ratios
You can change the ratio of the labels and fields by providing another parameter to `openAttributes` such as `[QUOTE(ADDON), "YourAttributeName", nil, [0.33, 0.66]] call mars_attributes_fnc_openAttributes`. The first element in the array is the scale of the label, the second element is the scale of the field.

## Storing attributes in the mission config
You can also create attribute configs straight into the mission by placing the config in the `description.ext`. The attributes framework will first search for the given config in the main `configFile` and lastly check `missionConfigFile`.

***

# Controls

{::options parse_block_html="true" /}

## Combo

#### Properties
{: .no-margin}

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
            <td>values</td>
            <td>string/array</td>
            <td>[]</td>
            <td>Values to use for each combo box item (<a href="https://community.bistudio.com/wiki/lbSetData">lbSetData</a>). You can either provide an array of values or a code string that returns an array of values</td>
        </tr>
        <tr>
            <td>labels</td>
            <td>string/array</td>
            <td>[]</td>
            <td>Text to use for each combo box item. You can either provide an array of strings or a code string that returns an array of strings</td>
        </tr>
        <tr>
            <td>selected</td>
            <td>number/string</td>
            <td>""</td>
            <td>Default selected option when first creating the control. It must match the data type of the items in <code>values</code>. If it’s a string then it’s <code>call compile</code>'d and must return the value</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the value of the control changes</td>
        </tr>
    </tbody>
</table>

#### Events
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>onLBSelChanged</td>
            <td>Fires when the selection in the combo box has changed. The left mouse button has been released and the new selection is fully made.</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Range {
    condition = "true";
    type = "COMBO";
    values[] = {1000, 2000, 3000, 4000, 5000};
    labels[] = {"1000m", "2000m", "3000m", "4000m", "5000m"};
    selected = 1000;
    expression = QUOTE([ARR_2(_this, 'range')] call FUNC(doThisFunction));
    onLBSelChanged = QUOTE(systemChat str _this);
};

class Years {
    condition = "true";
    type = "COMBO";
    values = "_years = []; for '_i' from 1982 to 2050 do {_years pushBack _i}; _years";
    labels = "_years = []; for '_i' from 1982 to 2050 do {_years pushBack str _i}; _years";
    selected = "date select 0";
    expression = QFUNC(doThisFunction);
};
```

## Slider

#### Properties
{: .no-margin}

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
            <td>range</td>
            <td>array</td>
            <td>[]</td>
            <td>Min and max range for the slider</td>
        </tr>
        <tr>
            <td>step</td>
            <td>number</td>
            <td>0</td>
            <td>Step to use when pressing left/right on the slider</td>
        </tr>
        <tr>
            <td>position</td>
            <td>number/string</td>
            <td>""</td>
            <td>Default position when first creating the control. It must be within the range. If it’s a string then it’s <code>call compile</code>'d and must return the position number</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the position of the control changes</td>
        </tr>
    </tbody>
</table>

#### Events
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>onSliderPosChanged</td>
            <td>Fires when changing the position of the slider.</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Overcast {
    condition = "true";
    type = "SLIDER";
    range[] = {0, 1};
    step = 0.1;
    position = "overcast";
    expression = "";
    onSliderPosChanged = QUOTE(\
        _ctrl = _this select 0;\
        _ctrl ctrlSetTooltip str (sliderPosition _ctrl);\
    );
};

class Range {
    condition = "true";
    type = "SLIDER";
    range[] = {0, 1000};
    step = 100;
    position = 500;
    expression = "";
    onSliderPosChanged = "";
};
```

## Edit

#### Properties
{: .no-margin}

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
            <td>rows</td>
            <td>number</td>
            <td>0</td>
            <td>Number of rows to draw (more than 1 will result in a multi-line edit box)</td>
        </tr>
        <tr>
            <td>textPlain</td>
            <td>string</td>
            <td>""</td>
            <td>Text value to be placed into the edit box</td>
        </tr>
        <tr>
            <td>textCode</td>
            <td>string</td>
            <td>""</td>
            <td>Code that returns the text value to be placed into the edit box</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the value of the control changes</td>
        </tr>
    </tbody>
</table>

#### Events
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>onSetFocus</td>
            <td>Input focus is on control. It now begins to accept keyboard input.</td>
        </tr>
        <tr>
            <td>onKillFocus</td>
            <td>Input focus is no longer on control. It no longer accepts keyboard input.</td>
        </tr>
        <tr>
            <td>onKeyDown</td>
            <td>Pressing any keyboard key. Fired before the onKeyUp event.</td>
        </tr>
        <tr>
            <td>onKeyUp</td>
            <td>Releasing any keyboard key. Fired after the onKeyDown event.</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Summary {
    condition = "true";
    type = "EDIT";
    rows = 5;
    textPlain = "";
    expression = "";
};

class Name {
    condition = "true";
    type = "EDIT";
    rows = 1;
    textCode = "name player";
    expression = "";
};
```

## Date

#### Properties
{: .no-margin}

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
            <td>year</td>
            <td>number/string</td>
            <td>0</td>
            <td>Default year value. If code string, it must return a number</td>
        </tr>
        <tr>
            <td>month</td>
            <td>number/string</td>
            <td>0</td>
            <td>Default month value. If code string, it must return a number</td>
        </tr>
        <tr>
            <td>day</td>
            <td>number/string</td>
            <td>0</td>
            <td>Default day value. If code string, it must return a number</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the value of the control changes</td>
        </tr>
    </tbody>
</table>

#### Events
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>onLBSelChanged</td>
            <td>Fires when the selection in the combo box has changed. The left mouse button has been released and the new selection is fully made.</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Date {
    condition = "true";
    type = "DATE";
    year = "date select 0";
    month = "date select 1";
    day = "date select 2";
    expression = QFUNC(setDateTime);
};

class FixedDate {
    condition = "true";
    type = "DATE";
    year = 1945;
    month = 11;
    day = 11;
    expression = QFUNC(setDateTime);
};
```

## Button

#### Properties
{: .no-margin}

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
            <td>Text to show on the button</td>
        </tr>
        <tr>
            <td>textCode</td>
            <td>string</td>
            <td>""</td>
            <td>Code that returns the text to show on the button</td>
        </tr>
        <tr>
            <td>action</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when pressing button</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Button {
    condition = "alive player";
    type = "BUTTON";
    textCode = "name player";
    action = "hint format ['Your name is %1', name player]";
};
```

## Label

#### Properties
{: .no-margin}

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

#### Examples
```c++
class Label {
    condition = "true";
    type = "LABEL";
    textPlain = "This is some text!";
};
```

## Checkbox

#### Properties
{: .no-margin}

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
            <td>Text to show on the checkbox's label</td>
        </tr>
        <tr>
            <td>textCode</td>
            <td>string</td>
            <td>""</td>
            <td>Code that returns the text to show on the checkbox's label</td>
        </tr>
        <tr>
            <td>checked</td>
            <td>bool/string</td>
            <td>false</td>
            <td>Whether the checkbox should already be checked. If a string is provided instead of a bool, it will be compiled and must return a boolean value</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the value of the control changes</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Checkbox1 {
    condition = "true";
    type = "CHECKBOX";
    textPlain = "Enable/Disable Something";
    checked = false;
};

class Checkbox2 {
    condition = "true";
    type = "CHECKBOX";
    textCode = "name player";
    checked = "alive player";
};
```

## Vector

#### Properties
{: .no-margin}

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

#### Examples
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

## Map

#### Properties
{: .no-margin}

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
            <td>position</td>
            <td>array/string</td>
            <td>[]</td>
            <td>Position array to center the map control on. If string is provided, it will be compiled and must return a position array</td>
        </tr>
        <tr>
            <td>expression</td>
            <td>string</td>
            <td>""</td>
            <td>Code to run when the user presses the final OK button. It will only run if the designated position of the map control changes (user clicks a position on the map)</td>
        </tr>
    </tbody>
</table>

#### Examples
```c++
class Map1 {
    condition = "true";
    type = "MAP";
    position[] = {0, 0, 0};
};

class Map2 {
    condition = "true";
    type = "MAP";
    position = "getPos player";
};
```
