
import sudoku
def print_solution(grid):
    for y in range(0,9):
        for x in range(0,9):
            print grid[x][y],
        print ""

def read_grid():
    grid = [[1,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0]]
    for y in range(0,9):
        line = raw_input()
        counter = 0
        for thing in line.split():
            grid[counter][y]=int(thing)
            counter+=1
    return grid

print_solution(sudoku.solve(read_grid()))
