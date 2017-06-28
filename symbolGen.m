function [ symbolVector, compareVector ] = symbolGen( bits, Eb )
%BERCALC Summary of this function goes here
%   Detailed explanation goes here    

    Es = 2*Eb;                     % energia do círculo interior    

    M = 4;                      % quantidade de símbolos no círculo

    %símbolos do círculo interior;
    theta = 0;

    %00
    m = 0;
    s0 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

    %01
    m = 1;
    s1 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

    %11
    m = 2;
    s3 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

    %10
    m = 3;
    s2 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));
   
    
    intermediario = [0 1 2 3];
    compareVector = [s0 s1 s2 s3];

    %Montando o vetor de símbolos
    symbolVector = reshape(bits, 2, length(bits)/2)';    
    symbolVector = (symbolVector(:,1)*2 + symbolVector(:,2)*1)';
    [~,idx] = ismember(symbolVector,intermediario);
    symbolVector = compareVector(idx);

end

