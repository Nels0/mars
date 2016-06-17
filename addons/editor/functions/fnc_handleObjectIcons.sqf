/*
 * Author: Kingsley
 * Handles object icons in 3D space
 * This function is called on every frame
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * N/A
 *
 * Public: No
 */

#include "script_component.hpp"

#define EMPTY_ARRAY GVAR(placedStaticObjects)
#define EXCLUDED_SIDES [sideAmbientLife]

GVAR(groupIcons) = [];
GVAR(unitIcons) = [];

{
    _grp = _x;
    _leader = leader _grp;
    _leaderPos = ASLtoAGL (getPosASLVisual _leader);
    _leaderDistance = _leaderPos distance GVAR(camPos);
    _grpUnits = units _grp;

    _alpha = [(linearConversion [0, GVAR(iconDrawDistance), _leaderDistance, 1, 0, true]), 1] select (_leader in GVAR(selection));
    _color = MARS_SIDECOLOR(side _grp);
    _color set [3, (_alpha max 0.1) max 0.5];

    _iconWidth = 1;
    _iconHeight = 1;

    if (!isNull GVAR(activeGroupIcon) && {GVAR(activeGroupIcon) == _grp}) then {
        _alpha = 1;
        _color set [3, 1];
        _iconWidth = GVAR(iconHoverSize);
        _iconHeight = GVAR(iconHoverSize);
    };

    if ({_x in GVAR(selection)} count _grpUnits == count _grpUnits) then {
        _alpha = 1;
        _color set [3, 1];
        _iconWidth = GVAR(iconHoverSize);
        _iconHeight = GVAR(iconHoverSize);
    };

    _texture = _grp getVariable [QGVAR(iconTexture), ""];
    if (_texture == "") then {
        _texture = [([_grp] call EFUNC(common,getMarkerType))] call EFUNC(common,getMarkerTexture);
        _grp setVariable [QGVAR(iconTexture), _texture];
    };

    _grpIconPos = [(_leaderPos select 0), (_leaderPos select 1), (_leaderPos select 2) + ICON_LEADER_HEIGHT];

    drawIcon3D [
        _texture,
        _color,
        _grpIconPos,
        _iconWidth,
        _iconHeight,
        0,
        "",
        0,
        0
    ];

    drawLine3D [
        _leaderPos,
        _grpIconPos,
        [0,0,0,_alpha]
    ];

    GVAR(groupIcons) pushBack [
        _grpIconPos,
        _grp
    ];

    _groupRenderedVehicles = [];
    _hasHighlightedUnit = false;

    {
        _unit = vehicle _x;
        _unitPos = ASLtoAGL (getPosASLVisual _unit);
        _unitDistance = _unitPos distance GVAR(camPos);
        _alpha = [(linearConversion [0, BOX_FADE_DISTANCE, _unitDistance, 1, 0, true]), 1] select (_unit in GVAR(selection));
        _color = if (alive _unit) then {MARS_SIDECOLOR(side group _unit)} else {[0,0,0,1]};
        _color set [3, _alpha];
        _unitIsUnderCursor = [_unit] call FUNC(isUnitScreenPosUnderCursor);

        _iconTexture = _unit getVariable [QGVAR(iconTexture), ""];
        if (_iconTexture == "") then {
            _icon = getText (configfile >> "CfgVehicles" >> (typeOf _unit) >> "icon");
            _iconTexture = getText (configfile >> "CfgVehicleIcons" >> (getText (configfile >> "CfgVehicles" >> (typeOf _unit) >> "icon")));
            _unit setVariable [QGVAR(iconTexture), _iconTexture];
        };
        
        if (_unitIsUnderCursor && _alpha >= 0.25 && !_hasHighlightedUnit) then {
            ["select"] call FUNC(setCursor);
            _alpha = 1;
            _color set [3, 1];
            _hasHighlightedUnit = true;
        };

        if (isPlayer _unit) then {
            _selColor = [0,0,0,_alpha];
            if (alive _unit) then {
                if (local _unit) then {
                    _selColor = [1,0,0,_alpha];
                } else {
                    _selColor = [1,0,0.5,_alpha];
                };
            } else {
                _selColor = [0,0,0,_alpha];
            };

            drawIcon3D [
                "\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa",
                _selColor,
                _unitPos,
                1,
                1,
                0,
                name _unit,
                1,
                0.031
            ];
        };

        drawIcon3D [
            _iconTexture,
            _color,
            _unitPos,
            1,
            1,
            0,
            "",
            1,
            0
        ];

        if ({_x in GVAR(selection)} count _grpUnits > 0) then {
            drawLine3D [
                [(_unitPos select 0), (_unitPos select 1), (_unitPos select 2) + 1],
                [(_leaderPos select 0), (_leaderPos select 1), (_leaderPos select 2) + 1],
                [(_color select 0), (_color select 1), (_color select 2), 0.25]
            ];
        };

        _groupRenderedVehicles pushBackUnique _unit;

        GVAR(unitIcons) pushBack [
            _unitPos,
            _unit
        ];

        false
    } count (_grpUnits select {
        (!(_x in _groupRenderedVehicles) && {(((ASLtoAGL (getPosASLVisual _x)) distance GVAR(camPos)) < GVAR(iconDrawDistance))})
    });

    false
} count (allGroups select {
    (!(side _x in EXCLUDED_SIDES) &&
    {(count (units _x) > 0)} && {
        (alive (leader _x) &&
        ((ASLtoAGL (getPosASLVisual (leader _x))) distance GVAR(camPos)) < (GVAR(iconDrawDistance) / 2))
    })
});

{
    _vehicle = _x;
    _vehiclePos = ASLtoAGL (getPosASLVisual _vehicle);
    _vehicleDistance = _vehiclePos distance GVAR(camPos);
    _alpha = [(linearConversion [0, BOX_FADE_DISTANCE, _vehicleDistance, 1, 0, true]), 1] select (_vehicle in GVAR(selection));
    _color = if (alive _vehicle) then {[COLOR_EMPTY_RGBA]} else {[0,0,0,1]};
    _color set [3, _alpha];

    _iconTexture = _vehicle getVariable [QGVAR(iconVehicleTexture), ""];
    if (_iconTexture == "") then {
        _icon = getText (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "icon");
        _iconTexture = if (_icon find "\a3\" > -1 || _icon find "\A3\" > -1) then {_icon} else {getText (configFile >> "CfgVehicleIcons" >> _icon)};
        _vehicle setVariable [QGVAR(iconVehicleTexture), _iconTexture];
    };

    if (_iconTexture == "") then {
        _iconTexture = "\A3\ui_f\data\map\vehicleicons\iconObject_ca.paa";
        _vehicle setVariable [QGVAR(iconVehicleTexture), _iconTexture];
    };

    drawIcon3D [
        _iconTexture,
        _color,
        _vehiclePos,
        1,
        1,
        0,
        "",
        1,
        0
    ];

    false
} count ((EMPTY_ARRAY + (vehicles select {count crew _x == 0})) select {
    ((count (crew _x) == 0) && (((ASLtoAGL (getPosASLVisual _x)) distance GVAR(camPos)) < GVAR(iconDrawDistance)))
});