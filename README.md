# 3DOF-Rocket-Simulation
Using MATLAB to simulate a rocket launch with constant acceleration (3DOF).

## Objective
Send a rocket from an initial altitude of 210 m across a full parabolic flight path and end at 220 m. 

This is accomplished by using MATLab's ode45 function to integrate the calculated velocity and acceleration vector over each time step.

## Initial Values
- Position: 210 m
- Velocity: .001 m/s
- Time: 0 s
- dTime: 0.1 s
- rocketLength: 2.87 m
- rocketDiameter: 0.122 m
- wetMass: 65.6 kg
- dryMass: 45.2 kg
- thrustDuration: 1.8 s
- thrustMagnitude: 21525 N
- initialTemperature: 300 K
- initialPressure: 99000 Pa
- specificGasConstant: 287.058 J/kg*K
- gravity: 9.8067 m/s^2
- lapseRate = -0.0065