function [ ber, receivedSymbols ] = berCalc2( bits, symbolVector, compareVector, N0, context, Eb )
%BERCALC2 Summary of this function goes here
%   context: define o canal e o equalizador de acordo com os itens pedidos
%   no roteiro. context pode valer 0, 1, 2, 3. 0 para AWGN, 1 para o item ii, 2 para o item iii, 3 para o
%   item iv.
%   
    
    %% canais e ru�do
    
    std = sqrt(N0/2);         % desvio padr�o do ru�do       
    
    switch(context)
        %canal AWGN
        case 0 
            receivedSymbols = symbolVector;
            receivedSymbols = receivedSymbols + randn(size(receivedSymbols))*std + 1j*randn(size(receivedSymbols))*std;    % adi��o de ru�do Normal com m�dia 0, desvio padr�o std    
    
        %canal item ii
        case 1
            receivedSymbols = zeros(1, length(symbolVector) + 2);   %sinal recebido alongado pelo canal
            
            %passando o sinal recebido pelo canal
            receivedSymbols = receivedSymbols + [(1/sqrt(2))*symbolVector 0 0];
            receivedSymbols = receivedSymbols + [0 (1j/2)*symbolVector 0];
            receivedSymbols = receivedSymbols + [0  0 (-1/2)*symbolVector];
            
            receivedSymbols = receivedSymbols + randn(size(receivedSymbols))*std + 1j*randn(size(receivedSymbols))*std;    % adi��o de ru�do Normal com m�dia 0, desvio padr�o std    
            
        %canal item iii
        case 2                                    
            %montando os blocos com N = 16 e G = 2
            N = 16;            
            G = 2;
            
            %acrescentando o prefixo c�clico
            symbolVector = reshape(symbolVector, N, length(symbolVector)/N)';
            symbolVector = [symbolVector(:, size(symbolVector, 2)) symbolVector(:, size(symbolVector, 2) - 1) symbolVector]';
            symbolVector = reshape(symbolVector, 1, size(symbolVector, 1)*size(symbolVector, 2));  
            
            %canal
            h1 = [1/sqrt(2) 1i/2 -1/2];  
            noise = sqrt(N0/2).*randn(1, length(symbolVector)) + (1i)*sqrt(N0/2).*randn(1, length(symbolVector));  
            
            %passando o sinal recebido pelo canal
            receivedSymbols = conv(h1, symbolVector);
            receivedSymbols = receivedSymbols(1:end-2);           
            receivedSymbols = receivedSymbols + noise;              
                        
            %removendo o prefixo c�clico
            receivedSymbols = reshape(receivedSymbols, N+G, length(receivedSymbols)/(N+G))';
            receivedSymbols = receivedSymbols(:, G+1:size(receivedSymbols,2))';
            receivedSymbols = reshape(receivedSymbols, 1, size(receivedSymbols, 1)*size(receivedSymbols, 2));
            
            %canal
            h1 = [1/sqrt(2) 1i/2 -1/2 zeros(1, length(receivedSymbols)-3)];            
            H1 = fft(h1);            
            
            %equalizador                        
            ZF = 1./H1;
            receivedSymbols = fft(receivedSymbols).*ZF;
            receivedSymbols = ifft(receivedSymbols);
                                                                       
%             %removendo o prefixo c�clico
%             receivedSymbols = reshape(receivedSymbols, N+G, length(receivedSymbols)/(N+G))';
%             receivedSymbols = receivedSymbols(:, G+1:size(receivedSymbols,2))';
%             receivedSymbols = reshape(receivedSymbols, 1, size(receivedSymbols, 1)*size(receivedSymbols, 2));
             
                                                
        %MMSE para sinal sem SC-FDE
        case 3
            Es = 2*Eb;
            h1 = [1/sqrt(2) 1i/2 -1/2 zeros(1, length(symbolVector)-3)];
            H1 = fft(h1);
            noise = sqrt(N0/2).*randn(1, length(symbolVector)) + (1i)*sqrt(N0/2).*randn(1, length(symbolVector));
            receivedSymbols = fft(symbolVector).*H1 + fft(noise);

            %equalizador
            MMSE = conj(H1)./(abs(H1).^2 + N0/Es);
            receivedSymbols = receivedSymbols.*MMSE;
            receivedSymbols = ifft(receivedSymbols);  
        
        %Zero Forcing para canal h sem SC-FDE
        case 4            
            %canal
            h1 = [1/sqrt(2) 1i/2 -1/2 zeros(1, length(symbolVector)-3)];
            noise = sqrt(N0/2).*randn(1, length(symbolVector)) + (1i)*sqrt(N0/2).*randn(1, length(symbolVector));
            H1 = fft(h1);
            
            %passando o sinal recebido pelo canal
            receivedSymbols = ifft(fft(symbolVector).*H1 + fft(noise));
            
            %equalizador                        
            ZF = 1./H1;
            receivedSymbols = fft(receivedSymbols).*ZF;
            receivedSymbols = ifft(receivedSymbols);
        
        %MMSE para canal h com SC-FDE    
        case 5 
            %montando os blocos com N = 16 e G = 2
            Es = 2*Eb;
            N = 16;            
            G = 2;
            
            %acrescentando o prefixo c�clico
            symbolVector = reshape(symbolVector, N, length(symbolVector)/N)';
            symbolVector = [symbolVector(:, size(symbolVector, 2)) symbolVector(:, size(symbolVector, 2) - 1) symbolVector]';
            symbolVector = reshape(symbolVector, 1, size(symbolVector, 1)*size(symbolVector, 2));  
            
            %canal
            h1 = [1/sqrt(2) 1i/2 -1/2];
            noise = sqrt(N0/2).*randn(1, length(symbolVector)) + (1i)*sqrt(N0/2).*randn(1, length(symbolVector));                        
            
            %passando o sinal recebido pelo canal
            receivedSymbols = conv(h1, symbolVector);
            receivedSymbols = receivedSymbols(1, 1:end-2);
            receivedSymbols = receivedSymbols + noise;                                                                     
            
            %removendo o prefixo c�clico
            receivedSymbols = reshape(receivedSymbols, N+G, length(receivedSymbols)/(N+G))';
            receivedSymbols = receivedSymbols(:, G+1:size(receivedSymbols,2))';
            receivedSymbols = reshape(receivedSymbols, 1, size(receivedSymbols, 1)*size(receivedSymbols, 2));   
  
            
            %canal
            h1 = [1/sqrt(2) 1i/2 -1/2 zeros(1, length(receivedSymbols)-3)];            
            H1 = fft(h1);
                                  
            %equalizador                        
            MMSE = conj(H1)./(abs(H1).^2 + N0/Es);
            receivedSymbols = fft(receivedSymbols).*MMSE;
            receivedSymbols = ifft(receivedSymbols);  
            
%             %removendo o prefixo c�clico
%             receivedSymbols = reshape(receivedSymbols, N+G, length(receivedSymbols)/(N+G))';
%             receivedSymbols = receivedSymbols(:, G+1:size(receivedSymbols,2))';
%             receivedSymbols = reshape(receivedSymbols, 1, size(receivedSymbols, 1)*size(receivedSymbols, 2));   
           
    end         
    
    %% extraindo sequ�ncia de bits do sinal transmitido

    estimatedSymbols = zeros(1, length(receivedSymbols));         %s�mbolos estimados    

    %compara e estima os s�mbolos recebidos
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

