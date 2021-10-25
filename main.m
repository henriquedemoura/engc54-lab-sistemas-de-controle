%% Avaliação de Conhecimento Prévio de Lab 6
% Discente: Henrique de Moura Sinezio

%% Modelo de Tanques Acoplados
clc
clear all
close all

%% Modelo Fenomenológico 

% Parâmetros temporais de simulação
dt    = 0.001;   % s
T     = 30;     % s

% Caso 1
Heq_1 = 40;     % cm
Heq_2 = 40;     % cm

% Caso 2
Heq_3 = 40;     % cm
Heq_4 = 20;     % cm

%[A1, A2, h1, h2] = modelo_fenomenologico(Heq_1, Heq_2, dt, T, 0, 0);
%[A3, A4, h3, h4] = modelo_fenomenologico(Heq_3, Heq_4, dt, T, 40, 40);

% Gráficos
%modelo_fenomenologico_plot(A1, A2, h1, h2, dt, T, Heq_1, Heq_2);
%modelo_fenomenologico_plot(A3, A4, h3, h4, dt, T, Heq_3, Heq_4);

%% Modelo Linearizado

delta = 1.5;

op1 = [3.75+delta, 3.75-delta];
op2 = [13.5-delta, 13.5+delta];
op3 = [24.5+delta, 24.5-delta];
op4 = [35.5-delta, 35.5+delta];
op5 = [45.25+delta, 45.25-delta];
op6 = [45.25-delta, 45.25+delta];
op7 = [47-delta, 47+delta];
op8 = [47+delta, 47-delta];

M_linear_1 = linearizacao(op1(1), op1(2), dt);
M_linear_2 = linearizacao(op2(1), op2(2), dt);
M_linear_3 = linearizacao(op3(1), op3(2), dt);
M_linear_4 = linearizacao(op4(1), op4(2), dt);
M_linear_5 = linearizacao(op5(1), op5(2), dt);
M_linear_6 = linearizacao(op6(1), op6(2), dt);
M_linear_7 = linearizacao(op7(1), op7(2), dt);
M_linear_8 = linearizacao(op7(1), op7(2), dt);

M_linear = {M_linear_1, M_linear_2, M_linear_3, M_linear_4, M_linear_5, M_linear_6, M_linear_7, M_linear_8};

tmp = size(M_linear);
num_de_pontos_de_operacao = tmp(2);

for n = 1:num_de_pontos_de_operacao
    tmp = M_linear{1,n};
    autovalores = eig(tmp);
    if ~(autovalores(1) < 0 && autovalores(2) < 0)
        display('Modelo ' + string(n) + ' NÃO é estável')    
    end
end

%% Desacoplamento

G_s = cell(1, num_de_pontos_de_operacao);
D_s = cell(1, num_de_pontos_de_operacao);
G_desacoplado = cell(1, num_de_pontos_de_operacao);

for n = 1:num_de_pontos_de_operacao
    m_linear_tmp = M_linear(n);
    m_linear_tmp = m_linear_tmp{1,1};
    [G_s{1,n}, D_s{1,n}, G_desacoplado{1,n}] = desacoplamento(m_linear_tmp);
end


%% Sintonia de Controlador  - Encontra o C(s) sem o ganho

C_s_1 = cell(1, num_de_pontos_de_operacao);
C_s_2 = cell(1, num_de_pontos_de_operacao);

C_s_1_k = cell(1, num_de_pontos_de_operacao);
C_s_2_k = cell(1, num_de_pontos_de_operacao);

for n = 1:num_de_pontos_de_operacao
    G_s_tmp = G_s{1,n};
    [C_s_1{1,n}, C_s_2{1,n}] = sintonia_zero(G_s_tmp, n);
end

%% Sintonia de Controlador  - Calcula o ganho de cada controlador manualmente

% n = 1; planta = G_s{1,n}; controlador = C_s_1{1,n}; rlocus(planta(1,1) * controlador)
% n = 1; planta = G_s{1,n}; controlador = C_s_2{1,n}; rlocus(planta(2,2) * controlador)

C_s_1_k{1,1} = C_s_1{1,1} * 300; %300
C_s_2_k{1,1} = C_s_2{1,1} * 1000; %1000

C_s_1_k{1,2} = C_s_1{1,2} * 300; %300
C_s_2_k{1,2} = C_s_2{1,2} * 1000;

C_s_1_k{1,3} = C_s_1{1,3} * 300; %400
C_s_2_k{1,3} = C_s_2{1,3} * 1000; %400

C_s_1_k{1,4} = C_s_1{1,4} * 300; %400
C_s_2_k{1,4} = C_s_2{1,4} * 1000; %1300

C_s_1_k{1,5} = C_s_1{1,5} * 300; %300
C_s_2_k{1,5} = C_s_2{1,5} * 1000; %100

C_s_1_k{1,6} = C_s_1{1,6} * 75; %300
C_s_2_k{1,6} = C_s_2{1,6} * 250; %100

C_s_1_k{1,7} = C_s_1{1,7} * 37.5; %300
C_s_2_k{1,7} = C_s_2{1,7} * 125; %100

C_s_1_k{1,8} = C_s_1{1,8} * 37.5; %300
C_s_2_k{1,8} = C_s_2{1,8} * 125; %100

%% Prints

op_v = [op1; op2; op3; op4; op5; op6; op7; op8];

resumo_c = zeros(8,8);

for n = 1:num_de_pontos_de_operacao
    c_pid_1 = pid(C_s_1_k{1,n});
    kp_1 = c_pid_1.Kp;
    ki_1 = c_pid_1.Ki;
    kd_1 = c_pid_1.Kd;
    
    c_pid_2 = pid(C_s_2_k{1,n});
    kp_2 = c_pid_2.Kp;
    ki_2 = c_pid_2.Ki;
    kd_2 = c_pid_2.Kd;
    
    tmp_v = horzcat(op_v(n, 1), op_v(n, 2), kp_1, ki_1, kd_1, kp_2, ki_2, kd_2);
    
    resumo_c(n,:) = tmp_v;
end

%% Plotar parâmetros por região

% Eixo x - Alturas possíveis
r_h = 0:0.01:49;
r_h_n = size(r_h);
r_h_n = r_h_n(2);
kp_plot = zeros(2, r_h_n);
ki_plot = zeros(2, r_h_n);
kd_plot = zeros(2, r_h_n);

[pack_ganhos] = ganhos(resumo_c);

[kp_fit_1_a, ki_fit_1_a, kd_fit_1_a,  ...
    kp_fit_1_b, ki_fit_1_b, kd_fit_1_b, ...
    kp_fit_2_a, ki_fit_2_a, kd_fit_2_a, ...
    kp_fit_2_b, ki_fit_2_b, kd_fit_2_b] = unpack_ganhos(pack_ganhos);

for i = 1:r_h_n-1
    % Kp
    if r_h(i) < 45 
        kp_plot(1,i) = polyval(kp_fit_1_a,r_h(i));
        kp_plot(2,i) = polyval(kp_fit_1_b,r_h(i));
    else
    	kp_plot(1,i) = polyval(kp_fit_2_a,r_h(i));
        kp_plot(2,i) = polyval(kp_fit_2_b,r_h(i));
    end
    %Ki
    if r_h(i) < 45 
        ki_plot(1,i) = polyval(ki_fit_1_a,r_h(i));
        ki_plot(2,i) = polyval(ki_fit_1_b,r_h(i));
    else
    	ki_plot(1,i) = polyval(ki_fit_2_a,r_h(i));
        ki_plot(2,i) = polyval(ki_fit_2_b,r_h(i));
    end
end

ax1 = plot(4,1,1);
plot(r_h, kp_plot(1,:))
xlim([0,49])
ylim([0,400])
title(ax1,'Ganho proporcional por nível (Tanque 1)')
ylabel(ax1, 'Kp')

figure
ax2 = plot(4,1,2);
plot(r_h, kd_plot(2,:))
xlim([0,49])
title(ax1,'Ganho proporcional por nível (Tanque 2)')
ylabel(ax1, 'Ki')
%% Teste com controlador

Heq_1 = 45;
Heq_2 = 20;
h1_0 = 45;
h2_0 = 45;
dt = 0.001;

[A1, A2, h1, h2] = modelo_fenomenologico(Heq_1, Heq_2, dt, T, h1_0, h2_0);
[A1_pi, A2_pi, h1_pi, h2_pi] = modelo_fenomenologico_com_controlador(Heq_1, Heq_2, dt, T,  h1_0, h2_0, resumo_c);

modelo_fenomenologico_plot(A1, A2, h1, h2, dt, T, Heq_1, Heq_2);
hold on
modelo_fenomenologico_plot(A1_pi, A2_pi, h1_pi, h2_pi, dt, T, Heq_1, Heq_2);
