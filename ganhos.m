function [pack_ganhos] = ganhos(resumo_c)

% Cálculo dos KPs
% P/ h < 45
% Tanque a
kp_fit_1_a = polyfit(resumo_c(1:6,1),resumo_c(1:6,3),1);
ki_fit_1_a = polyfit(resumo_c(1:6,1),resumo_c(1:6,4),1);
kd_fit_1_a = polyfit(resumo_c(1:6,1),resumo_c(1:6,5),1);
% Tanque b
kp_fit_1_b = polyfit(resumo_c(1:6,2),resumo_c(1:6,6),1);
ki_fit_1_b = polyfit(resumo_c(1:6,2),resumo_c(1:6,7),1);
kd_fit_1_b = polyfit(resumo_c(1:6,2),resumo_c(1:6,8),1);
% P/ h > 45
% Tanque a
kp_fit_2_a = polyfit(resumo_c(5:8,1),resumo_c(5:8,3),1);
ki_fit_2_a = polyfit(resumo_c(5:8,1),resumo_c(5:8,4),1);
kd_fit_2_a = polyfit(resumo_c(5:8,1),resumo_c(5:8,5),1);
% Tanque b
kp_fit_2_b = polyfit(resumo_c(5:8,2),resumo_c(5:8,6),1);
ki_fit_2_b = polyfit(resumo_c(5:8,2),resumo_c(5:8,7),1);
kd_fit_2_b = polyfit(resumo_c(5:8,2),resumo_c(5:8,8),1);

pack_ganhos = {kp_fit_1_a, ki_fit_1_a, kd_fit_1_a,  ...
          kp_fit_1_b, ki_fit_1_b, kd_fit_1_b, ...
          kp_fit_2_a, ki_fit_2_a, kd_fit_2_a, ...
          kp_fit_2_b, ki_fit_2_b, kd_fit_2_b};
end