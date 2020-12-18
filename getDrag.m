function [drag] = getDrag(s, density, velocity, coeffOfDrag, magVelocity)
    % inputs
    x = velocity(1,1); % m/s
    y = velocity(1,2); % m/s
    z = velocity(1,3); % m/s
    
    % calculations
    newDragX = -0.5*density*magVelocity*coeffOfDrag*s*x; % N
    newDragY = -0.5*density*magVelocity*coeffOfDrag*s*y; % N
    newDragZ = -0.5*density*magVelocity*coeffOfDrag*s*z; % N
    
    % output
    drag = [newDragX, newDragY, newDragZ];
end