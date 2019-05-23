function [ sacc ] = sacc_velocity(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if length(x)<6
    sacc=0;
else
    vel= abs(x(end)- x(length(x)-5))/6;
    
    if vel>33
        sacc=1;
    else
        sacc=0;
end


end

