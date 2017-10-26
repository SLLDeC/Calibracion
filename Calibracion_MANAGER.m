%% Experimento Calibración
% Funciona con 2 arduinos: master_tone_ingka.ino y slave_servo.ino
% Testea diferentes fiteos de las asincronías temporales de cada escalon
clear all; delete('temporal_ent.mat');delete('temporal_exp.mat');
delete(instrfind);

%% Definiciones Experimento

% Numero de bips por trial.
N_stim = 20;
% Repeticiones por condicion.
n=10;
n_calibracion=10;
n_entrenamiento=1;
% Parametros Calibración
out_limit=150;
% Perturbaciones mecanicas
mech_sizes = [33 100]; % tamaï¿½o de la perturbaciï¿½n
% mech_sizes = [103]; % tamaï¿½o de la perturbaciï¿½n
servo_ini_pos=57;
mech_bip_range = [10 13];    % rango de bip
cond_mech = max(size(mech_sizes));

%% 1. Registra datos del sujeto
dir=pwd;
exp='calibracion';
[ sujeto,sujeto_number ] = f_DatosSujeto(dir, exp);

%% Abre archivos temporales
tent = fopen('temporal_cal_ent','w');
texp = fopen('temporal_cal_exp','w');

%% Entrenamiento
step=1;
[trial,bad] = Loop_central_ALTURAS(step,N_stim,n,n_entrenamiento,servo_ini_pos,cond_mech,mech_sizes,mech_bip_range);

% Guarda los datos
sujeto(sujeto_number).ent=trial;
clear trial

if  isempty(bad) == 0
    sujeto(sujeto_number).ent_bad=bad;
    clear bad
else
end

disp('Fin del entrenamiento. Presione una tecla para comenzar con el experimento');
disp(' ');
pause()

%% Guarda todos los datos
save('sujetos_calibracion.mat','sujeto')

%% Calibración
step=2;
[trial,bad] = Loop_central_ALTURAS(step,N_stim,n,n_entrenamiento,servo_ini_pos,cond_mech,mech_sizes,mech_bip_range);

% Guarda los datos
sujeto(sujeto_number).exp=trial;
clear trial

if  isempty(bad) == 0
    sujeto(sujeto_number).exp_bad=bad;
    clear bad
else
end

disp('Fin de la primera parte.! Presione una tecla para continuar');
disp(' ');
pause()

%% Parametros del experimento
temp_sizes = parametros_calibracion_exp(sujeto);

%% Experimento
step=3;
[trial,bad] = Loop_central_ALTURAS(step,N_stim,n,n_entrenamiento,servo_ini_pos,cond_mech,mech_sizes,mech_bip_range);

disp('Fin del experimento.¡Muchas gracias por participar!');
disp(' ');

%% Guarda todos los datos
save('sujetos_calibracion.mat','sujeto')