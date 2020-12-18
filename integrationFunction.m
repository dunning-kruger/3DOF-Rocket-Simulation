function [xDot, drag, thrust, mass, acceleration] = integrationFunction(time, x)
    % constants
    gravity         = 9.8067; % m/s^2
    initialAltitude = 210; % m
    rocketLength    = 2.87; % m
    rocketDiameter  = 0.122; % m
    thrustDuration  = 1.8; % s
    thrustMagnitude = 21525; % N
    launchMass      = 65.6; % kg
    
    % initialization
    launchClear      = initialAltitude + rocketLength;
    timeTable        = [0 1.8 1.8001 3];
    thrustTable      = [21525 21525 0 0];
    massTable        = [65.6 45.2 45.2 45.2];
    
    % calculations
    launchClearSpeed               = sqrt(2*(thrustMagnitude/launchMass)*rocketLength);
    position                       = x(1:3)';
    velocity                       = x(4:6)';
    altitude                       = position(3);
    magVelocity                    = (velocity(1,1).^2 + velocity(1,2).^2 + velocity(1,3).^2).^.5;
    normVel                        = norm(velocity);
    s                              = ((rocketDiameter/2)^2)*pi;
    [~, ~, density, acousticSpeed] = getConditions(altitude);
    machNumber                     = normVel/acousticSpeed;
    coeffDrag                      = getCD(machNumber, time, thrustDuration);
    
    % output
    drag         = getDrag(s, density, velocity, coeffDrag, magVelocity);
    mass         = interp1(timeTable, massTable, time, 'linear', 'extrap');
    thrust       = (velocity/norm(velocity))*interp1(timeTable,thrustTable,time,'linear','extrap');    
    acceleration = getAcceleration(altitude, launchClear, thrust, drag, gravity, mass, launchClearSpeed, magVelocity);
    xDot         = [velocity'; acceleration'];
end