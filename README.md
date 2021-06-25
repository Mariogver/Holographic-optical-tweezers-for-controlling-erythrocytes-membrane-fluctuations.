# Holographic-optical-tweezers-for-controlling-erythrocytes-membrane-fluctuations.

The functions AOStoMatCalibration.m, CalibraciónCentral.m, Calibration.m, MatCoord.m and MatCoord_2.m are for the Camera/MATLAB pixel calibration. To design the traps in the correct positions to perform the linear regression TrapDraw.m fucntion is employed.

ImagScPo.m and sumacelda.m are requirement functions designed to help in the progress of other routines.

DonutPrecise.m, perimetro.m, perimetro_2.m, Draw_2.m and vertices.m are the trap-designing scripts for different morphologies based on stored object images. 

GSAcor.m and Lens.m are the funcions in charge of the Gerchberg-Saxton algorithm implementation.

PhasemaskSend_Nicco.m sends the to be displayed phasemask to the SML. 

Main_detect_and_trap.m is a wholistic function in which a image is screened in search of an object, the object is detected, its trap and phasemask designed and sent to the SML. With this script any spherical object can be trapped in less than a minute. 

any errors or questions can be addressed to mario.garcia-verdugo@alumnos.upm.es 
