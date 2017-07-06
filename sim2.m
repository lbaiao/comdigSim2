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
berIII_2 = zeros(1, it);
berIV = zeros(1, it);
berIV_2 = zeros(1, it);
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

theoryBerAWGN = 0.5.*erfc(sqrt(Eb_N0_pow));

figure(1)
semilogy(Eb_N0_db(1:9), berAWGN(1:9), Eb_N0_db(1:9), theoryBerAWGN(1:9))
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Item I - Canal AWGN'});
ylabel('BER');
legend('Simulação', 'Teoria')

%% 1.II Cálculo BER para Eb/N0 de 0db a 12db para canal item ii
for i=1:length(berII)
    [ berII(i), receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0(i), 1, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(2)
semilogy(1:1:12, berII)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Item II - Canal h[k], sem equalização'});
ylabel('BER');

%% 1.III Cálculo BER para Eb/N0 de 0db a 12db para canal item iii
for i=1:length(berIII)
    [ berIII(i), receivedSymbols ] = berCalc2( bitsIII, symbolVectorIII, compareVector, N0(i), 2, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

% for i=1:length(berIII_2)
%     [ berIII_2(i), receivedSymbols ] = berCalc2( bitsIII, symbolVectorIII, compareVector, N0(i), 5, Eb );
%     display(strcat('iteração: ',' ', int2str(i)))    
% end

figure(3)
semilogy(1:1:12, berIII, 1:1:12, berIII_2)
xlabel('Eb/N0 db');
% title({'BER x Eb/N0 - Item III - SC-FDE, N=16, G=2, equalizador ZF'});
title({'BER x Eb/N0 - Item III - SC-FDE, N=16, G=2'});
ylabel('BER');
% legend('ZF')
legend('ZF', 'MMSE')

%% 1.IV Cálculo BER para Eb/N0 de 0db a 12db para canal item iv
for i=1:length(berIII_2)
    [ berIII_2(i), receivedSymbols ] = berCalc2( bitsIII, symbolVectorIII, compareVector, N0(i), 5, Eb );
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(4)
semilogy(1:1:12, berIII_2)
xlabel('Eb/N0 db');
title({'BER x Eb/N0 - Item IV - SC-FDE, N=16, G=2, equalizador MMSE'});
ylabel('BER');
legend('MMSE')