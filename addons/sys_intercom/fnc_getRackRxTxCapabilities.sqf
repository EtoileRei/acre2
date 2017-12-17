/*
 * Author: ACRE2Team
 * Returns the configuration (No use, TX Ony, RX only or TX/RX) for the given unit of a rack that is connected to an intercom.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 * 1: Vehicle where the radio rack is <OBJECT>
 * 2: Unit <OBJECT>
 *
 * Return Value:
 * Radio functionality: 0 (Not Monitoring), 1 (Receive only), 2 (Transmit only) and 3 (Receive and Transmit) <NUMBER>
 *
 * Example:
 * ["acre_vrc110_id_1", vehicle acre_player, acre_player] call acre_sys_intercom_fnc_getRackRxTxCapabilities
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_vehicle", "_unit", ["_rackId", ""]];

private _varName = ([_vehicle, _unit] call FUNC(getStationVariableName)) + "_rack";

if (_varName isEqualTo "_rack") exitWith {
    ERROR_2("unit %1 not found in vehicle %2",_unit,_vehicle);
};

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

private _functionality = RACK_NO_MONITOR;
private _found = false;

{
    if (_x select 0 == _rackId) then {
        _functionality = _x select 1;
        _found = true;
    };

    if (_found) exitWith {};
} forEach (_vehicle getVariable [_varName, []]);

_functionality
