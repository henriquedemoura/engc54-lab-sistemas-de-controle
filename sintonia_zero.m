
function [C_s_1, C_s_2] = sintonia_zero(G_desacoplado, zona)

s = tf('s');
C_s = cell(1,2);

%% Cálculo do PI do Tanque 1 e 2 SEM GANHO
for n = 1:2
    G_s_unico = G_desacoplado(n,n);
    G_s_zpk = zpk(G_s_unico);

    % O zero (ação integral) do controlador está 5% à esquerda do polo mais à esquerda
    % Adicionamos o zero p/ ter melhor resposta em regime permanente
    if abs(G_s_zpk.P{1,1}(1)) > abs(G_s_zpk.P{1,1}(2))
        zero = G_s_zpk.P{1,1}(1);
    else
        zero = G_s_zpk.P{1,1}(2);
    end
    zero_controlador = - 1.05 * zero;
    
    C_s{1,n} = 1 + zero_controlador/s;
end

%% Resultados

C_s_1 = C_s{1, 1};
C_s_2 = C_s{1, 1};
end