
del *.obj

SET COMMAND="C:\Program Files (x86)\Intel\Composer XE\bin\compilervars.bat" intel64

CALL %COMMAND%

icl -c /O2 src\src_amigo\*.c /I"include/include_amigo" /I"include/include_cvodes" /I"include/include_de" /I"include/include_f2c" /Qmkl   
icl -c /O2 src\src_cvodes\*.c /I"include/include_cvodes"  /Qmkl
icl -c /O2 src\src_de\*.c /I"include/include_de" /I"include/include_amigo" /I"include/include_cvodes" /Qmkl
icl -c /O2 src\src_SRES\*.c /I"include/include_SRES" /I"include/include_amigo" /I"include/include_cvodes"  /I"include/include_f2c"  /I"include/include_de" /Qmkl
icl -c /O2 src\src_nl2sol\*.c  /I"include/include_f2c" /Qmkl
icl -c /O2 src\src_mxInterface\AMIGO_mxInterface.c /I"include/include_f2c" /I"include/include_de" /I"include/include_cvodes" /I"include/include_amigo" /I"include/include_mxInterface" /I"C:\MATLAB_R2015b_64\extern\include" /Qmkl 

lib /out:"lib_win64\libAMIGO.lib"  *.obj  "lib_win64\libf2c.lib" 

del *.obj

icl -c /O2 src\src_mxInterface\lib_AMIGO_entry.c -DEXPORT /I"include/include_f2c" /I"include/include_de" /I"include/include_cvodes" /I"include/include_amigo" /I"include/include_mxInterface" /I"C:\MATLAB_R2015b_64\extern\include" /Qmkl 

link /out:lib_win64\sharedAMIGO.dll *.obj "lib_win64\libAMIGO.lib" /DLL "C:\MATLAB_R2015b_64\extern\lib\win64\microsoft\libmx.lib" "C:\MATLAB_R2015b_64\extern\lib\win64\microsoft\libmat.lib" "C:\MATLAB_R2015b_64\extern\lib\win64\microsoft\libmex.lib"

del *.obj
