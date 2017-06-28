%Comunica��es Digitais - Simula��o 2 - 1/2017
%
%
%
%Alunos:
%
%
%

%Gera a sequ�ncia de 100000 + 2 bits aleat�rios:
bits = randi([0, 1], 1,1E5);

it = 12;    %qtde de itera��es

receivedSymbols = [];

Eb = 1;     
berAWGN = zeros(1, it);
berII = zeros(1, it);
berIII = zeros(1, it);
berIV = zeros(1, it);
Eb_N0_db = 1:1:it;        %Eb/N0 em dB

Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;

% Gerando o vetor de s�mbolos

[symbolVector, compareVector] = symbolGen(bits, Eb);

%% 1.I C�lculo BER para Eb/N0 de 0db a 12db para canal AWGN
for i=1:length(berAWGN)
    [ berAWGN(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 0 );
    display(strcat('itera��o: ',' ', int2str(i)))    
end

figure(1)
semilogy(1:1:12, berAWGN)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal AWGN'});
ylabel('BER');

%% 1.II C�lculo BER para Eb/N0 de 0db a 12db para canal item ii
for i=1:length(berII)
    [ berII(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 1 );
    display(strcat('itera��o: ',' ', int2str(i)))    
end

figure(2)
semilogy(1:1:12, berII)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal item II'});
ylabel('BER');

%% 1.III C�lculo BER para Eb/N0 de 0db a 12db para canal item iii
for i=1:length(berIII)
    [ berIII(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 2 );
    display(strcat('itera��o: ',' ', int2str(i)))    
end

figure(3)
semilogy(1:1:12, berIII)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal item III'});
ylabel('BER');