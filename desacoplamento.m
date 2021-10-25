function [G_s, D_s, G_desacoplado] = desacoplamento(M_linear)

s = tf('s');
I = eye(2);
tmp_a = minreal(inv(s*I - M_linear.a));
tmp_b = mtimes(M_linear.c, tmp_a);
tmp_c = mtimes(tmp_b, M_linear.b);
G_s =  tmp_c + M_linear.d;

tmp_d = minreal(inv(G_s));
T_s = minreal([G_s(1,1), 0; 0, G_s(2,2)]);
D_s = minreal(mtimes(T_s, tmp_d), 1e-3);

G_desacoplado = minreal(D_s * G_s, 1e-3);
end