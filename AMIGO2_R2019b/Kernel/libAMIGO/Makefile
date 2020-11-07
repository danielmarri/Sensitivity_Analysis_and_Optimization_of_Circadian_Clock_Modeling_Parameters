#This is dependent on your installation, please modify it accordinglyIGO_LIBS=$(PWD)/lib_linux64

SRC=$(wildcard $(PWD)/src/src_amigo/*.c)
SRC+=$(wildcard $(PWD)/src/src_cvodes/*.c)
SRC+=$(wildcard $(PWD)/src/src_nl2sol/*.c)
SRC+=$(wildcard $(PWD)/src/src_de/*.c)
SRC+=$(wildcard $(PWD)/src/src_SRES/*.c)

MEX+=$(wildcard $(PWD)/src/src_mxInterface/AMIGO_mxInterface.c)
MEX+=$(wildcard $(PWD)/src/src_mxInterface/lib_AMIGO_entry.c)

AMIGO_LIBS=lib_linux64

MODEL=$(wildcard $(PWD)/tests/circadian/amigoRHS.c)

CIRCADIAN=$(wildcard $(PWD)/tests/circadian/*.c)

JULIA=$(wildcard $(PWD)/src/src_nl2sol/juliaAMIGO.c)

INC+=-I$(PWD)/include/include_f2c/
INC+=-I$(PWD)/include/include_cvodes/
INC+=-I$(PWD)/include/include_mxInterface/
INC+=-I$(PWD)/include/include_amigo/
INC+=-I$(PWD)/include/include_de/
INC+=-I$(PWD)/include/include_SRES/
INC+=-I$(MATLAB_PATH)/extern/include

CLIBS+=-L$(AMIGO_LIBS) -L$(MATLAB_LIB) -Wl,-rpath,$(MATLAB_LIB)
CLIBS+=-lm -lmex -lmx -lmat -lmxInterface -lAMIGO -lf2c -fopenmp  -lmwblas -lmwlapack

CFLAGS += -fopenmp -MMD -std=c99 $(INC) -DINTEGER_STAR_8  -DMATLAB  -fPIC -DEXPORT $(CLIBS)
LDFLAGS += $(CLIBS)

OBJFILES := $(SRC:.c=.o)
DEPFILES := $(SRC:.c=.d)

OBJMEX := $(MEX:.c=.o)
DEPMEX := $(MEX:.c=.d)

libAMIGO.a : $(OBJFILES)
	ar r $(AMIGO_LIBS)/libAMIGO.a $?
	
libmxInterface.a : $(OBJMEX)
	ar r $(AMIGO_LIBS)/libmxInterface.a $?
    
clean :
	rm -f $(OBJFILES) $(OBJMEX) $(DEPMEX) $(DEPFILES)   src/src_mxInterface/AMIGO_mxInterface.o lib_linux64/mxInterface.a lib_linux64/libAMIGO.a
-include $(DEPFILES)
-include $(DEPMEX)
-include $(DEPMEDES)
