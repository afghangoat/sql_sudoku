# SQL sudoku solver

The **S**e**Q**ue**L** of my Sudoku algorithm implemented in Excel. This time, it is implemented using MySQL queries.

## Usage

The algorithm can only solve puzzles which have a single way solution. Also it solves for the 2 vertical lines.

Place the puzzle inside the table, each number goes to a [row][column]. (For reference, see the import methods)
If a cell is empty, place a 0 inside, otherwise a number between 1-9.

The input of the program will be your filled table. A select query will be ran and you will get the solution as a 2D matrix.