function [M_linear] = linearizacao(Heq_1op, Heq_2op, dt)
    clc

    syms h_1 h_2 q_in1 q_in2; 

    %% Ponto de operação

    % Vamos utilizar o meio do tanque como ponto de operação.

    % Variáveis auxiliares
    d1 = 8;     % [cm] Distancia fixa face frontal do tanque 1
    d2 = 14;    % [cm] Distancia fixa face frontal do tanque 2
    dp = 9;     % [cm] Profundidade do tanque
    k1 = 250;     % [cm^5/2/s]
    k2 = 250;    % [cm^5/2/s]
    kac = 200;   % [cm^5/2/s]

    % Pontos de Operação
    tg_alpha = 12/6;
    
    % Definindo A1(h1)
    if Heq_1op >= 0 && Heq_1op <= 7.5
        A1 = dp * d1;
    end
    if Heq_1op > 7.5 && Heq_1op <= 19.5
        d1_var = (Heq_1op - 7.5) / tg_alpha;
        A1 = dp * (d1 + d1_var);
    end
    if Heq_1op > 19.5 && Heq_1op <= 29.5
        d1_var = 6;
        A1 = dp * (d1 + d1_var);
    end
    if Heq_1op > 29.5 && Heq_1op <= 41.5
        d1_var = (41.5 - Heq_1op) / tg_alpha;
        A1 = dp * (d1 +  d1_var);
    end
    if Heq_1op > 41.5
        A1 = dp * d1;
    end
    
    % Definindo A2(h2)
    if Heq_2op >= 0 && Heq_2op <= 7.5
        A2 = dp * (d2 + 6);
    end
    if Heq_2op > 7.5 && Heq_2op <= 19.5
        d2_var = (19.5 - Heq_2op) / tg_alpha;
        A2 = dp * (d2 + d2_var);
    end
    if Heq_2op > 19.5 && Heq_2op <= 29.5
        A2 = dp * d2;
    end
    if Heq_2op > 29.5 && Heq_2op <= 41.5
        d2_var = (Heq_2op - 29.5) / tg_alpha;
        A2 = dp * (d2 + d2_var);
    end
    if Heq_2op > 41.5
        A2 = dp * (d2 + 6);
    end
    

    if Heq_1op > Heq_2op
        Qeq_1 = k1 * sqrt(Heq_1op) + kac * sqrt(abs(Heq_1op - Heq_2op));
        Qeq_2 = k2 * sqrt(Heq_2op) - kac * sqrt(abs(Heq_1op - Heq_2op));
    elseif Heq_1op < Heq_2op
        Qeq_1 = k1 * sqrt(Heq_1op) - kac * sqrt(abs(Heq_1op - Heq_2op));
        Qeq_2 = k2 * sqrt(Heq_2op) + kac * sqrt(abs(Heq_1op - Heq_2op));
    elseif Heq_1op == Heq_2op
        Qeq_1 = k1 * sqrt(Heq_1op);
        Qeq_2 = k2 * sqrt(Heq_2op);
    end

    %% Definindo funções não lineares

    if Heq_1op > Heq_2op
        f1 = (q_in1 - k1 * sqrt(h_1) - kac*sqrt(abs(h_1-h_2))) / A1;
        f2 = (q_in2 - k2 * sqrt(h_2) + kac*sqrt(abs(h_1-h_2))) / A2;
    elseif Heq_1op < Heq_2op
        f1 = (q_in1 - k1 * sqrt(h_1) + kac*sqrt(abs(h_1-h_2))) / A1;
        f2 = (q_in2 - k2 * sqrt(h_2) - kac*sqrt(abs(h_1-h_2))) / A2;
    elseif Heq_1op == Heq_2op
        f1 = (q_in1 - k1 * sqrt(h_1)) / A1;
        f2 = (q_in2 - k2 * sqrt(h_2)) / A2;
    end

    %% Definindo funções de saída

    g1 = h_1;
    g2 = h_2;

    a11 = diff(f1, h_1);
    a12 = diff(f1, h_2);
    a21 = diff(f2, h_1);
    a22 = diff(f2, h_2);

    b11 = diff(f1, q_in1);
    b12 = diff(f1, q_in2);
    b21 = diff(f2, q_in1);
    b22 = diff(f2, q_in2);

    c11 = diff(g1, h_1);
    c12 = diff(g1, h_2);
    c21 = diff(g2, h_1);
    c22 = diff(g2, h_2);

    d11 = diff(g1, q_in1);
    d12 = diff(g1, q_in2);
    d21 = diff(g2, q_in1);
    d22 = diff(g2, q_in2);

    A11 = subs(a11, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    A12 = subs(a12, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    A21 = subs(a21, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    A22 = subs(a22, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});

    B11 = subs(b11, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    B12 = subs(b12, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    B21 = subs(b21, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    B22 = subs(b22, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});

    C11 = subs(c11, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    C12 = subs(c12, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    C21 = subs(c21, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    C22 = subs(c22, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});

    D11 = subs(d11, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    D12 = subs(d12, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    D21 = subs(d21, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});
    D22 = subs(d22, {h_1, q_in1, h_2, q_in2}, {Heq_1op, Qeq_1, Heq_2op, Qeq_2});

    A = eval([A11 A12; A21 A22]);
    B = eval([B11 B12; B21 B22]);
    C = eval([C11 C12; C21 C22]);
    D = eval([D11 D12; D21 D22]);

    M_linear = ss(A,B,C,D, dt);

    % Caso 1
    %h = stepplot(M_linear,30)
    %xlabel('tempo[s]');
    %ylabel('nivel[cm]');
    %title('Resposta ao degrau u = 40 cm')

end