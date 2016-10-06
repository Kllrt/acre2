/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["","_key","","","_shift"];

// Ignore all interaction if radio is not on manual Channel Selection
private _manualChannelSelection = ["getState", "manualChannelSelection"] call GUI_DATA_EVENT;
if (_manualChannelSelection != 1) exitWith {};

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
_dir = -1;
if(_key == 0) then {
    _dir = 1;
};

//If shift is pressed, perform a step by +-5
if(_shift) then {
    _dir = _dir*5;
};

private _knobPosition = ["getState", "kHzKnobPosition"] call GUI_DATA_EVENT;
private _channelSpacing = ["getState", "channelSpacing"] call GUI_DATA_EVENT;
if (_channelSpacing == 1) then {
   _dir = _dir*2;
   if (_knobPosition%2 == 1) then {
      _knobPosition = _knobPosition - 1;
  };
};
private _newKnobPosition = _knobPosition + _dir;

if(_knobPosition != _newKnobPosition) then {
    //Allow a jump over the null position
    if (_newKnobPosition > 39) then {
        _newKnobPosition = 0;
    };
    if (_newKnobPosition < 0) then {
        if(_channelSpacing == 1) then {
            _newKnobPosition = 38;
        } else {
            _newKnobPosition = 39;
        };
    };
    ["setState", ["kHzKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

    // Switch Channel with argument -1 to show manual mode
    ["setCurrentChannel", -1] call GUI_DATA_EVENT;

    ["Acre_SEM52Knob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
