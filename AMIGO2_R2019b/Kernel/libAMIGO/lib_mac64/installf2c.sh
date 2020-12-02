#!/bin/sh
############################################################
# This UNIX script builds the f2c FORTRAN --> C translator #
# under Mac OS X.                                          #
# Make this script executable with "chmod +x buildf2c"     #
############################################################
echo "==================================="
echo "Build f2c FORTRAN --> C translator."
echo "==================================="
echo "USAGE:  ./buildf2c"

######################################
# Set trap to allow abort on signal: #
######################################
trap 'echo "Interrupted by signal" >&2; exit' 1 2 3 15

########################################################
# 1. Download f2c source from Bell Labs.               #
# (Tar file is not visible - it's created on the fly.) #
########################################################
echo "--------------------------------------------"
echo "1. Downloading f2c source from Bell Labs ..."
echo "--------------------------------------------"
#wget --passive-ftp ftp://netlib.bell-labs.com/netlib/f2c.tar
#curl http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c -o "f2c.tar"
echo "... done."

#####################################
# 2. Uncompress f2c tarred archive: #
#####################################
echo "-------------------------------"
echo "2. Uncompressing f2c source ..."
echo "-------------------------------"
tar -xvf f2c.tar
gunzip -rf f2c/*
cd f2c
unzip libf2c.zip -d libf2c
cd ..
echo "... done."

###############################################################
# 3. Prepare the unix makefiles for building the f2c library. #
#    Note: CC compiler switched from 'cc' to '/usr/bin/cc'   #
###############################################################
echo "-------------------------------------------"
echo "3. Preparing makefiles for building f2c ..."
echo "-------------------------------------------"
sed 's/CC = cc/CC = \/usr\/bin\/cc/' f2c/libf2c/makefile.u > f2c/libf2c/makefile
sed 's/CC = cc/CC = \/usr\/bin\/cc/' f2c/src/makefile.u > f2c/src/makefile
echo "... done."

##########################################
# 4. Create and install f2c header file. #
# If you use a C++ compiler:  make hadd  #
# Otherwise:                  make f2c.h #
##########################################
echo "----------------------------------------------------"
echo "4. Creating and installing f2c header file f2c.h ..."
echo "----------------------------------------------------"
cd f2c/libf2c
make f2c.h


################################################
# 5. Create and install f2c library "libf2c.a" #
################################################
echo "-----------------------------------------------------"
echo "5. Creating and installing f2c library "libf2c.a" ..."
echo "-----------------------------------------------------"
make
cp libf2c.a ../../libf2c.a 
echo "... done."

exit


