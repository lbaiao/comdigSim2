%Comunicações Digitais - Simulação 2 - 1/2017
%
%
%
%Alunos:
%
%
%

%Gera a sequência de 100000 aleatórios:
bits = randi([0, 1], 1,1E5);

%Sequência com 32 bits adicionais para o item iii
bitsIII = randi([0, 1], 1,1E5 + 32);

it = 12;    %qtde de iterações

receivedSymbols = [];

Eb = 1;     
berAWGN = zeros(1, it);
berII = zeros(1, it);
berIII = zeros(1, it);
berIV = zeros(1, it);
Eb_N0_db = 1:1:it;        %Eb/N0 em dB

Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;

% Gerando o vetor de símbolos

[symbolVector, compareVector] = symbolGen(bits, Eb);
[symbolVectorIII, ~] = symbolGen(bitsIII, Eb);

%% 1.I Cálculo BER para Eb/N0 de 0db a 12db para canal AWGN
for i=1:length(berAWGN)
    [ berAWGN(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 0, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(1)
semilogy(1:1:12, berAWGN)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal AWGN'});
ylabel('BER');

%% 1.II Cálculo BER para Eb/N0 de 0db a 12db para canal item ii
for i=1:length(berII)
    [ berII(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 1, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(2)
semilogy(1:1:12, berII)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal item II'});
ylabel('BER');

%% 1.III Cálculo BER para Eb/N0 de 0db a 12db para canal item iii
for i=1:length(berIII)
    [ berIII(i), receivedSymbols ] = berCalc2( bitsIII, symbolVectorIII, compareVector, N0(i), 2, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(3)
semilogy(1:1:12, berIII)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal item III'});
ylabel('BER');

%% 1.III Cálculo BER para Eb/N0 de 0db a 12db para canal item iv
for i=1:length(berIV)
    [ berIV(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 2, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(4)
semilogy(1:1:12, berIV)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Canal item IV'});
ylabel('BER');