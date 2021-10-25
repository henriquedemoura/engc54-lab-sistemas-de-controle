function [qin, ultima_integral, ultimo_erro] = pi_tanque(h, erro, ultima_integral, ultimo_erro, dt, tanque, pack_ganhos)

% O equacionamento do desacoplamento não entra aqui pq a transformada Z
% de D(s) com Ts = dt << 0.01 é aproximadamente uma matriz diagonal.

% Encontra kp e ki p/ cada controlador
[kp_fit_1_a, ki_fit_1_a, kd_fit_1_a,  ...
          kp_fit_1_b, ki_fit_1_b, kd_fit_1_b, ...
          kp_fit_2_a, ki_fit_2_a, kd_fit_2_a, ...
          kp_fit_2_b, ki_fit_2_b, kd_fit_2_b] = unpack_ganhos(pack_ganhos);
      
if tanque == 1
    if h < 45
        kp = polyval(kp_fit_1_a, h);
        ki = polyval(ki_fit_1_a, h);
        kd = polyval(kd_fit_1_a, h);
    else
        kp = polyval(kp_fit_2_a, h);
        ki = polyval(ki_fit_2_a, h);
        kd = polyval(kd_fit_2_a, h);
    end
else
    if h < 45
        kp = polyval(kp_fit_1_b, h);
        ki = polyval(ki_fit_1_b, h);
        kd = polyval(kd_fit_1_b, h);
    else
        kp = polyval(kp_fit_2_b, h);
        ki = polyval(ki_fit_2_b, h);
        kd = polyval(kd_fit_2_b, h);
    end
end

% Calcula integral do erro
integral = ultima_integral + erro * dt;
derivativo = (ultimo_erro - erro) / dt;

% Calcula u(t)
qin = kp * erro + ki * integral + kd * derivativo;

if tanque == 2
    %display(erro);
    %display(derivativo);
    %display(qin);
end

% Correção de saturação
if qin < 0
    qin = 0;
end

% Salva valor da ultima integral
ultima_integral = integral;
ultimo_erro = erro;
end