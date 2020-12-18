function [temperature, pressure, density, acousticSpeed] = getConditions(altitude)
    % constants
    gravity             = 9.8067; % m/s^2
    initialTemperature  = 300; % K
    initialPressure     = 99000; % Pa
    lapseRate           = -0.0065;
    initialAltitude     = 210; % m
    specificGasConstant = 287.058; % J/kg*K
    
    % ouptut
    temperature   = initialTemperature + lapseRate*(altitude-initialAltitude);
    pressure      = initialPressure*((temperature/initialTemperature)^(-gravity/(lapseRate*specificGasConstant)));
    density       = pressure/(specificGasConstant*temperature);
    acousticSpeed = (1.4*specificGasConstant*temperature)^0.5;
end