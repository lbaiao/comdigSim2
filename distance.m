function [ d ] = distance( s1, s2 )
%DISTANCE Dist�ncia entre dois n�meros complexos
%   Detailed explanation goes here

d = sqrt((real(s2) - real(s1))^2 + ((imag(s2)-imag(s1))^2));

end

