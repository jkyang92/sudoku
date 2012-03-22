
    
cdef extern from "Solver.h" namespace "CMSat":
    ctypedef int Var
    cdef cppclass Lit:
        Lit(int,bint)
        Lit unsign()
        Lit operator~()
    cdef cppclass vec[T]:
        void push(T&)
        void clear()
        T& operator[](int)
    cdef cppclass lbool:
        char getchar()
        bint operator==(lbool&)
        bint operator!=(lbool&)
        pass
    cdef lbool l_True
    cdef lbool l_False
    cdef lbool l_Undef
    cdef cppclass Solver:
        Solver()
        Var newVar()  except +
        bint addClause(vec[Lit]&)  except +
        bint addXorClause(vec[Lit]&,bint)  except +
        lbool solve(vec[Lit]&)  except +
        void handleSATSolution()
        bint okay()
        lbool modelValue(Lit& x)
        bint dumpOrigClauses(char*)
        

cdef Lit varForSquare(x,y,val):
    return Lit(x*81+y*9+val-1,False);

cdef blocks(Solver* solver):
    cdef vec[Lit] curr
    for x in range(0,3):
        for y in range (0,3):
            for k in range(1,10):
                for x1off in range(0,3):
                    for y1off in range(0,3):
                        for x2off in range(0,3):
                            for y2off in range(0,3):
                                # do them in some sane order
                                if x1off*3+y1off<x2off*3+y2off:
                                    curr.push(~varForSquare(x*3+x1off,y*3+y1off,k));
                                    curr.push(~varForSquare(x*3+x2off,y*3+y2off,k));
                                    solver.addClause(curr);
                                    curr.clear();
                    
cdef lines(Solver* solver):
    cdef vec[Lit] hline
    cdef vec[Lit] vline
    for offset in range(0,9):
        for k in range(1,10):
            for i in range(0,9):
                for j in range(i+1,9):
                    hline.push(~varForSquare(i,offset,k));
                    hline.push(~varForSquare(j,offset,k));
                    vline.push(~varForSquare(offset,i,k));
                    vline.push(~varForSquare(offset,j,k));
                    solver.addClause(hline);
                    solver.addClause(vline);
                    hline.clear();
                    vline.clear();


cdef squares(Solver* solver):
    cdef vec[Lit] cond1#gaurentee that no box has two values
    cdef vec[Lit] cond2#gaurentee that each box has a value
    for x in range(0,9):
        for y in range(0,9):
            for k in range(1,10):
                cond2.push(varForSquare(x,y,k))
                for j in range(k+1,10):
                    cond1.push(~varForSquare(x,y,k))
                    cond1.push(~varForSquare(x,y,j))
                    solver.addClause(cond1)
                    cond1.clear()
            solver.addClause(cond2)
            cond2.clear();

def solve(grid):
    cdef vec[Lit] assumptions
    cdef Solver* solver
    solver = new Solver()
    for i in range(0,9*9*9):
        solver.newVar()
    squares(solver)
    lines(solver)
    blocks(solver)
    
    for x in range(0,9):
        for y in range(0,9):
            if grid[x][y]>0 and grid[x][y]<10:
                assumptions.push(varForSquare(x,y,grid[x][y]))
    
    result = [
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0]]
    if solver.solve(assumptions)==l_True:
        print "Success"
        #solver.handleSATSolution()
        for x in range(0,9):
            for y in range(0,9):
                for k in range(1,10):
                    if solver.modelValue(varForSquare(x,y,k))==l_True:
                        result[x][y]=k
                        
    else:
        print "Puzzle has no solution"
    return result
