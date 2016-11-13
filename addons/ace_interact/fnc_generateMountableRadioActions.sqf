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

params ["_target","","_params"];
_params params ["_rackClassName"];

private _actions = [];

private _radioList = [] call acre_api_fnc_getCurrentRadioList;
_radioList = [_rackClassName,_radioList] call EFUNC(sys_rack,getMountableRadios);

{
    private _baseRadio = [_x] call acre_api_fnc_getBaseRadio;
    private _item = ConfigFile >> "CfgWeapons" >> _baseRadio;
    private _displayName = getText(_item >> "displayName");
    private _currentChannel = [_x] call acre_api_fnc_getRadioChannel;
    _displayName = format["Mount %1 Chn: %2",_displayName, _currentChannel];
    private _picture = getText(_item >> "picture");
    private _isActive = _x isEqualTo _currentRadio;

    private _action = [_x, _displayName, _picture, {
        params ["_target","_unit","_params"];
        _params params ["_rackClassName","_radioId"];
        [_rackClassName,_radioId,_unit] call EFUNC(sys_rack,mountRadio);
    }, {true}, {}, [_rackClassName,_x]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach (_radioList);


_actions;