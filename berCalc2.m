function [ ber, receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0, context )
%BERCALC Summary of this function goes here
%   context: define o canal e o equalizador de acordo com os itens pedidos
%   no roteiro. context pode valer 0, 1, 2, 3. 0 para AWGN, 1 para o item ii, 2 para o item iii, 3 para o
%   item iv.
%   
    
    %% canais e ruído
    
    std = sqrt(N0);         % desvio padrão do ruído       
    
    switch(context)
        %canal AWGN
        case 0 
            receivedSymbols = symbolVector;
            receivedSymbols = receivedSymbols + randn(size(receivedSymbols))*std + 1j*randn(size(receivedSymbols))*std;    % adição de ruído Normal com média 0, desvio padrão std    
    
        %canal item ii
        case 1
            receivedSymbols = zeros(1, length(symbolVector) + 2);   %sinal recebido alongado pelo canal
            
            %passando o sinal recebido pelo canal
            receivedSymbols = receivedSymbols + [(1/sqrt(2))*symbolVector 0 0];
            receivedSymbols = receivedSymbols + [0 (1j/2)*symbolVector 0];
            receivedSymbols = receivedSymbols + [0  0 (-1/2)*symbolVector];
            
            receivedSymbols = receivedSymbols + randn(size(receivedSymbols))*std + 1j*randn(size(receivedSymbols))*std;    % adição de ruído Normal com média 0, desvio padrão std    
            
        %canal item iii
        case 2
            receivedSymbols = zeros(1, length(symbolVector) + 2);   %sinal recebido alongado pelo canal
            h = [1/sqrt(2) 1j/2 -1/2];      %reposta do canal            
            
            %passando o sinal recebido pelo canal
            receivedSymbols = receivedSymbols + [(1/sqrt(2))*symbolVector 0 0];
            receivedSymbols = receivedSymbols + [0 (1j/2)*symbolVector 0];
            receivedSymbols = receivedSymbols + [0  0 (-1/2)*symbolVector];
            
            receivedSymbols = receivedSymbols + randn(size(receivedSymbols))*std + 1j*randn(size(receivedSymbols))*std;    % adição de ruído Normal com média 0, desvio padrão std    
            
            %equalizador
            H = fft(h);
            ZF = ifft(1./H);
            receivedSymbols = conv(receivedSymbols,ZF);
                                    
            
        %canal item iv
        case 3
    end         
    
    %% extraindo sequência de bits do sinal transmitido

    estimatedSymbols = zeros(1, length(receivedSymbols));         %símbolos estimados    

    %compara e estima os símbolos recebidos
    for i = 1:length(receivedSymbols)
        d = distance(receivedSymbols(i), compareVector(1));
        estimatedSymbols(i) = compareVector(1);
        for j = 1:length(compareVector)
            d_ij = distance(receivedSymbols(i), compareVector(j));
            if d_ij < d
                d = d_ij;
                estimatedSymbols(i) = compareVector(j);
            end
        end             
    end
    
    %montando o vetor bits estimados
    intermediario = [0 0; 0 1; 1 0; 1 1]';
    [~,idx] = ismember(estimatedSymbols, compareVector);
    estimatedBits = intermediario(:,idx);
    estimatedBits = reshape(estimatedBits, 1, size(estimatedBits, 1)*size(estimatedBits, 2));

    %% calculando a ber

    erros = 0;

    for i = 1:length(bits)
        if bits(i) ~= estimatedBits(i)
            erros = erros + 1;
        end
    end

    ber = erros/length(bits);
end

