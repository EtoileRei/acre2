/*
 * Author: ACRE2Team
 * Handles entering a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit entering a vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player] call acre_sys_rack_fnc_enterVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

if (_unit != _vehicle) then {
    private _initialized = _vehicle getVariable [QGVAR(initialized), false];

    if (!_initialized) then {
        // Only initialize if we are first in the crew array - This helps prevent multiple requests if multiple players enter a vehicle around the same time.
        private _crew = crew _vehicle;
        private _firstPlayer = objNull;
        {
            if (!isNull _firstPlayer) exitWith {};
            if (isPlayer _x) exitWith {
                _firstPlayer = _x;
            };
        } forEach _crew;

        if (!isNull _firstPlayer) then {
            if (_unit == _firstPlayer) then {
                [_vehicle] call FUNC(initVehicle);

                // Give some time for the racks to initialise properly
                [{
                    [_this] call FUNC(configureRackIntercom);
                }, _vehicle, 0.5] call CBA_fnc_waitAndExecute;
            };
        } else { // No other players.
            [_vehicle] call FUNC(initVehicle);

            // Give some time for the racks to initialise properly
            [{
                [_this] call FUNC(configureRackIntercom);
            }, _vehicle, 0.5] call CBA_fnc_waitAndExecute;
        };
    };

    // Enable the PFH if it is not active. This can only happen if the unit is using an external radio before entering the vehicle
    if (GVAR(rackPFH) == -1) then {
        GVAR(rackPFH) = [DFUNC(rackPFH), 1.1, [_unit, _vehicle]] call CBA_fnc_addPerFrameHandler;
    };
};
