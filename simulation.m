clc
clear 
close all

% initial values
time           = 0; % s
dt             = 0.1; % s
position       = [0, 0, 210]; % m
velocity       = .001; % m/s
azimuth        = 45; % degrees
angleOfAttack  = 45; % degrees
thrustDuration = 1.8; % s
altitude       = 210; % s
range          = 0; % m

% initialization
returnData     = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
theta          = 90 - angleOfAttack; % degrees
phi            = 90 - azimuth; % degrees
velocityX      = velocity*sind(theta)*cosd(phi); % m/s
velocityY      = velocity*sind(theta)*sind(phi); % m/s
velocityZ      = velocity*cosd(theta); % m/s
velocityVector = [velocityX, velocityY, velocityZ]; % m/s

while altitude <= 220
    initialState   = [position';velocityVector'];
    [t, solution] = ode45(@integrationFunction, [time, time+dt], initialState);
    [xDot, drag, thrust, mass, acceleration] = integrationFunction(time+dt, initialState);
    newState = solution(end,:);
    
    normVelocityOutter = norm(velocityVector);
    normAcceleration   = norm(acceleration);
    range              = norm(position);
    magXY              = (((velocityVector(1,1)^2)+(velocityVector(1,2)^2))^.5);
    flightAngle        = atand(velocityVector(1,3)/magXY);
    newIterationData   = [time,position(1,1),position(1,2),position(1,3), velocityVector(1,1), velocityVector(1,2), velocityVector(1,3), normVelocityOutter, acceleration(1,1), acceleration(1,2), acceleration(1,3), normAcceleration, drag(1,1), drag(1,2), drag(1,3), mass, flightAngle];
    
    position       = newState(1:3)';
    velocityVector = newState(4:6)';
    time           = time + dt;
    altitude       = position(3);
    
    returnData     = cat(1,returnData, newIterationData);
    position       = position';
    velocityVector = velocityVector';
end

while altitude > 220
    initialState   = [position';velocityVector'];
    [t, solution] = ode45(@integrationFunction, [time, time+dt], initialState);
    [xDot, drag, thrust, mass, acceleration] = integrationFunction(time+dt, initialState);
    newState = solution(end,:);
    
    normVelocityOutter = norm(velocityVector);
    normAcceleration = norm(acceleration);
    range = norm(position);
    magXY = (((velocityVector(1,1)^2)+(velocityVector(1,2)^2))^.5);
    flightAngle = atand(velocityVector(1,3)/magXY);
    newIterationData = [time,position(1,1),position(1,2),position(1,3), velocityVector(1,1), velocityVector(1,2), velocityVector(1,3), normVelocityOutter, acceleration(1,1), acceleration(1,2), acceleration(1,3), normAcceleration, drag(1,1), drag(1,2), drag(1,3), mass, flightAngle];
    
    if newState(1,3) < 220
        newState = solution(12,:);
        position = newState(1:3);
        time = t(12,:);
        velocityVector = newState(4:6);
        newIterationData = [time,position(1,1),position(1,2),position(1,3), velocityVector(1,1), velocityVector(1,2), velocityVector(1,3), normVelocityOutter, acceleration(1,1), acceleration(1,2), acceleration(1,3), normAcceleration, drag(1,1), drag(1,2), drag(1,3), mass, flightAngle];
        altitude = 219;
    else
        position = newState(1:3)';
        velocityVector = newState(4:6)';
        altitude = position(3);
    end
    
    time = time + dt;
    returnData = cat(1,returnData, newIterationData);
    position = position';
    velocityVector = velocityVector'; 
end

timeData = returnData(:,1);
xdata = returnData(:,2);
ydata = returnData(:,3);
zdata = returnData(:,4);
normVData = returnData(:,8);
normAData = returnData(:,12);
fPAngleData = returnData(:,17);

% write data to file
% dataTable = [timeData, xdata, ydata, zdata];
% csvwrite('outputData.txt',dataTable);

% plot simulation data
subplot(2,3,1)
plot(ydata,zdata)
title('Z vs Y')
xlabel('Y')
ylabel('Z')

subplot(2,3,2)
plot(timeData,zdata)
title('Z vs Time')
xlabel('Time')
ylabel('Z')

subplot(2,3,3)
plot(timeData,normVData)
title('Speed vs Time')
xlabel('Time')
ylabel('Speed')

subplot(2,3,4)
plot(timeData,normAData)
title('Acceleration Magnitude vs Time')
xlabel('Time')
ylabel('Acceleration Magnitude')

subplot(2,3,5)
plot(timeData,fPAngleData)
title('Flight Path Angle vs Time')
xlabel('Time')
ylabel('Flight Path Angle')

% display relevant data from simulation
fprintf('Range: %4.4g m\n', range)
fprintf('Time of flight: %4.4g s\n',timeData(end,:))
fprintf('Impact coordinates (x,y,z) = (%4.4g m, %4.4g m, %4.4g m)\n', xdata(end,:), ydata(end,:), zdata(end,:))
fprintf('Max velocity of %4.4g km/s was at %4.4g s\n', normVData(20,:), timeData(20,:))