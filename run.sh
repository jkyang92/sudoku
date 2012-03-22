if [ -z "$CMSAT_DIR" ]
then
    #this is just where it is on my computer
    CMSAT_DIR="../cryptominisat-2.9.2"
fi

PYTHONPATH=. LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CMSAT_DIR}/Solver/.libs" python main.py
