import random


colors = ["red", "green", "blue", "yellow", "purple"]


class Dot:
    def __init__(self, row, col, color):
        self.row = row
        self.col = col
        self.color = color
class Grid:
    def __init__(self, size):
        self.size = size
        self.data = []
        for i in range(size + 1):
            temp = []
            for j in range(size + 1):
                temp.append("")
            self.data.append(temp)
def make_grid(size):
    size = size + 1
    grid = Grid(size)
    for row in range(1, size):
        for col in range(1, size):
            color = colors[random.randint(0,4)]
            grid.data[row][col] = Dot(row, col, color)
    for i in range(size+1):
        grid.data[0][i] = Dot(0,i, "blank")
        grid.data[size][i] = Dot(size, i, "blank")
    for i in range(size+1):
        grid.data[i][0] = Dot(i, 0, "blank")
        grid.data[i][size] = Dot(i, size, "blank")

    return grid
def print_grid(grid):
    for i in range(1, grid.size):
        for j in range(1, grid.size):
            print(grid.data[i][j].color[0], end="  ")
        print('')
def playable(grid):
    for i in range(1, grid.size):
        for j in range(1, grid.size):
            if grid.data[i][j].color == grid.data[i-1][j].color or grid.data[i][j].color == grid.data[i+1][j].color or grid.data[i][j].color == grid.data[i][j+1].color or grid.data[i][j].color == grid.data[i][j-1].color:
                return True
    return False
def leagl(r1, c1, r2, c2):
    if r1 == r2:
        if c1 == c2 - 1 or c1 == c2 + 1:
            return True
    elif c1 == c2:
        if r1 == r2 - 1 or r1 == r2 + 1:
            return True
    else:
        return False
def grid_fall(grid, clear_tup):
    i = clear_tup[0]
    while i > 0:
        grid.data[i][clear_tup[1]] = grid.data[i-1][clear_tup[1]]
        i -= 1
    color = colors[random.randint(0, 4)]
    grid.data[1][clear_tup[1]] = Dot(1, clear_tup[1], color)
    return grid

def circ(clear_list):
    for item in clear_list:
        count = 0
        for other in clear_list:
            if leagl(item[0], item[1], other[0], other[1]):
                count += 1
        if count < 2:
            return False
    return True

def turn(grid):
    row_prev = int(input("give a row: "))
    col_prev = int(input("give a coloum: "))
    clear_list = [(row_prev, col_prev)]
    while True:
        row = int(input("give a row: "))
        col = int(input("give a coloum: "))
        if grid.data[row_prev][col_prev].color == grid.data[row][col].color and leagl(row_prev, col_prev, row, col) :
            clear_list.append(((row,col)))
            print("connection")
            stop = input("are you done with your move? y/n: ")
            if stop == "y":
                if circ(clear_list):
                    colr = grid.data[row_prev][col_prev].color
                    for i in range(1, grid.size):
                        for j in range(1, grid.size):
                            if grid.data[i][j].color == colr:
                                clear_list.append((i,j))
                clear_list.sort(key=lambda y: y[0])
                for thing in clear_list:
                    grid = grid_fall(grid, thing)
                return grid
            else:
                row_prev = row
                col_prev = col
        ss = input("new starting point? y/n: ")
        if ss == "y":
            return grid


def play(grid):
    print_grid(grid)
    while playable(grid):
        grid = turn(grid)
        print_grid(grid)

def main():
    grid = make_grid(6)
    play(grid)

if __name__ == '__main__':
    main()
