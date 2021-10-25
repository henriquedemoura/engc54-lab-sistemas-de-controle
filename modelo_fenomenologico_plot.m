function modelo_fenomenologico_plot(A1, A2, h1, h2, dt, T, Heq_1, Heq_2)

figure()
subplot(2,1,1)
tempo = 0:dt:T;
plot(tempo, h1,'b','LineWidth',2)
xlabel('tempo[s]'); ylabel('nivel[cm]')
hold on
plot(tempo, h2,'r','LineWidth',2)
xlabel('tempo[s]'); ylabel('nivel[cm]')
grid
legend('N�vel do tanque 1', 'Nivel do tanque 2')
titulo = 'Ponto de equil�brio h1(t) = ' + string(Heq_1) + ' cm e h2(t) = ' + string(Heq_2) + ' cm';
title(titulo)

subplot(2,1,2)
tempo = 0:dt:T-dt;
plot(tempo, A1,'b','LineWidth',2)
xlabel('tempo[s]'); ylabel('�rea[cm2]')
hold on
plot(tempo, A2,'r','LineWidth',2)
xlabel('tempo[s]'); ylabel('�rea[cm2]')
grid
legend('�rea do tanque 1', '�rea do tanque 2')
titulo = 'Ponto de equil�brio h1(t) = ' + string(Heq_1) + ' cm e h2(t) = ' + string(Heq_2) + ' cm';
title(titulo)
hold off

end