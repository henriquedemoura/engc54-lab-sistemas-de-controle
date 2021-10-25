function [A1, A2, h1, h2] = modelo_fenomenologico(Heq_1, Heq_2, dt, T,  h0_1, h0_2)
% Heq_1 = Ponto desejado pra altura do tanque 1
% Heq_1 = Ponto desejado pra altura do tanque 2
% dt = Intervalo de tempo da simulação
% T = Tempo total da simulação


%% Parâmetros do Tanque
d1 = 8;     % [cm] Distancia fixa face frontal do tanque 1
d2 = 14;    % [cm] Distancia fixa face frontal do tanque 2
dp = 9;     % [cm] Profundidade do tanque
k1 = 250;     % [cm^5/2/s]
k2 = 250;    % [cm^5/2/s]
kac = 200;   % [cm^5/2/s]
alpha = 60;
tg_alpha = 12/6;

%% Ponto de operação

if Heq_1 > Heq_2
    Qeq_1 = k1 * sqrt(Heq_1) + kac * sqrt(abs(Heq_1 - Heq_2));
    Qeq_2 = k2 * sqrt(Heq_2) - kac * sqrt(abs(Heq_1 - Heq_2));
elseif Heq_1 < Heq_2
    Qeq_1 = k1 * sqrt(Heq_1) - kac * sqrt(abs(Heq_1 - Heq_2));
    Qeq_2 = k2 * sqrt(Heq_2) + kac * sqrt(abs(Heq_1 - Heq_2));
elseif Heq_1 == Heq_2
    Qeq_1 = k1 * sqrt(Heq_1);
    Qeq_2 = k2 * sqrt(Heq_2);
end

%% Equacionamento do Sistema

N = T/dt;   % Número de iterações

% Vazão de entrada constante
qin1 = Qeq_1 * ones(1,N);
qin2 = Qeq_2 * ones(1,N);
qac  = zeros(1,N);
A1 = zeros(1,N);
A2 = zeros(1,N);
h1 = zeros(1,N);
h2 = zeros(1,N);

% Condição inicial
h1(1) = h0_1;
h2(1) = h0_2;

d1_min = 8; % [cm]
d1_var = 0; % [cm]

d2_min = 14;
d2_var = 0;

for i=1:N
    
    % Definindo A1(h1)
    if h1(i) >= 0 && h1(i) <= 7.5
        A1(i) = dp * d1_min;
    end
    if h1(i) > 7.5 && h1(i) <= 19.5
        d1_var = (h1(i) - 7.5) / tg_alpha;
        A1(i) = dp * (d1_min + d1_var);
    end
    if h1(i) > 19.5 && h1(i) <= 29.5
        d1_var = 6;
        A1(i) = dp * (d1 + d1_var);
    end
    if h1(i) > 29.5 && h1(i) <= 41.5
        d1_var = (41.5 - h1(i)) / tg_alpha;
        A1(i) = dp * (d1 +  d1_var);
    end
    if h1(i) > 41.5
        A1(i) = dp * d1;
    end
    
    % Definindo A2(h2)
    if h2(i) >= 0 && h2(i) <= 7.5
        A2(i) = dp * (d2_min + 6);
    end
    if h2(i) > 7.5 && h2(i) <= 19.5
        d2_var = (19.5 - h2(i)) / tg_alpha;
        A2(i) = dp * (d2_min + d2_var);
    end
    if h2(i) > 19.5 && h2(i) <= 29.5
        A2(i) = dp * d2_min;
    end
    if h2(i) > 29.5 && h2(i) <= 41.5
        d2_var = (h2(i) - 29.5) / tg_alpha;
        A2(i) = dp * (d2_min + d2_var);
    end
    if h2(i) > 41.5
        A2(i) = dp * (d2_min + 6);
    end
    
    if h1(i) > h2(i)
        qac(i) = kac * sqrt(abs(h1(i) - h2(i)));
    elseif h1(i) < h2(i)
        qac(i) = -kac * sqrt(abs(h1(i) - h2(i)));
    end
    if h1(i) == h2(i)
        qac(i) = 0;
    end
    
    qout1 = k1 * sqrt(h1(i));
    qout2 = k2 * sqrt(h2(i));
    
    h1(i+1) = (dt/A1(i)) * (qin1(i) - qout1 - qac(i)) + h1(i);
    % Correção de saturações
    if h1(i+1) < 0
        h1(i+1) = 0;
    end
    if h1(i+1) > 49
        h1(i+1) = 49;
    end
    
    h2(i+1) = (dt/A2(i)) * (qin2(i) - qout2 + qac(i)) + h2(i);
    % Correção de Saturações
    if h2(i+1) < 0
        h2(i+1) = 0;
    end
    if h2(i+1) > 49
        h2(i+1) = 49;
    end
end

end