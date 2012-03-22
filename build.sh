if [ -z "$CMSAT_DIR" ]
then
    #this is just where it is on my computer
    CMSAT_DIR="../cryptominisat-2.9.2"
fi

CPPFLAGS="-I${CMSAT_DIR}/Solver/ -I${CMSAT_DIR}/mtl/ -I${CMSAT_DIR}/MTRand/ -g" LDFLAGS="-L${CMSAT_DIR}/Solver/.libs/" python setup.py build_ext -i
