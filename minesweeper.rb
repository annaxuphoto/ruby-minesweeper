=begin
Write your code for the 'Minesweeper' exercise in this file. Make the tests in
`minesweeper_test.rb` pass.
To get started with TDD, see the `README.md` file in your
`ruby/minesweeper` directory.
=end

# input is an array of strings, each representing a row
# ex:
#   0 1 2 3 4
# 0 - * - * -
# 1 - - * - -
# 2 - - * - -
# 3 - - - - -
#
# increment spots at [x+1, y], [x-1, y], [x, y+1], [x, y-1], [x+1, y+1], [x-1, y+1], [x+1, y-1], [x-1, y-1] for each mine
# edge cases: border positions (handle out of bounds), mines, invalid board
# (all strings in input should be same length and contain pluses, dashes, pipes, spaces or asterisks--and should be strings)
# valid border: top/bottom pluses/dashes, pipes on left and right of all other strings

class Board

  PLUS = '+'.freeze
  DASH = '-'.freeze
  PIPE = '|'.freeze
  SPACE = ' '.freeze
  MINE = '*'.freeze

  # returns a solved Minesweeper board, given an unsolved board
  # inp: array of string literals
  # returns array of string literals
  def self.transform(inp)

    # check for valid borders

    raise ArgumentError, 'Board requires a top and bottom border' if inp.length < 2

    expected_line_length = inp[0].length
    solution = Array.new(inp.length) {
      empty_row = ''
      (1..expected_line_length).each do
        empty_row += SPACE
      end
      empty_row
    }
    [0, inp.length - 1].each do |index|
      raise ArgumentError, 'All rows must be the same length' unless inp[index].length == expected_line_length

      [0, inp[index].length - 1].each do |expected_plus|
        raise ArgumentError, "Borders must have '#{PLUS}' in all four corners" unless inp[index][expected_plus] == PLUS

        solution[index][expected_plus] = PLUS
      end

      (1..(inp[index].length - 2)).each do |expected_dash|
        raise ArgumentError, "Border edges should be denoted by a '#{DASH}'" unless inp[index][expected_dash] == DASH

        solution[index][expected_dash] = DASH
      end
    end

    (1..(inp.length - 2)).each do |row|
      raise ArgumentError, 'All rows must be the same length' unless inp[row].length == expected_line_length

      [0, inp[row].length - 1].each do |expected_pipe|
        raise ArgumentError, "All content rows must be enclosed in '#{PIPE}'s" unless inp[row][expected_pipe] == PIPE

        solution[row][expected_pipe] = PIPE
      end
      (1..inp[row].length - 2).each do |minesweeper_cell|
        unless inp[row][minesweeper_cell] == SPACE || inp[row][minesweeper_cell] == MINE
          raise ArgumentError, "Expected either '#{SPACE}' or '#{MINE}' but received #{inp[row][minesweeper_cell]}"
        end

        handle_mine(row, minesweeper_cell, solution) if inp[row][minesweeper_cell] == MINE
      end
    end

    solution
  end

  # increments counts of all cells surrounding a given mine
  # mine_x: x coordinate of mine
  # mine_y: y coordinate of mine
  # board_to_modify: the Minesweeper board being transformed
  def self.handle_mine(mine_x, mine_y, board_to_modify)

    board_to_modify[mine_x][mine_y] = MINE

    unless mine_x <= 1 # mine is not on top row
      # mine is not on top left corner
      increment_count(mine_x - 1, mine_y - 1, board_to_modify) unless mine_y <= 1

      increment_count(mine_x - 1, mine_y, board_to_modify)

      # mine is not on top right corner
      increment_count(mine_x - 1, mine_y + 1, board_to_modify) unless mine_y >= board_to_modify[mine_x].length - 2
    end

    unless mine_x >= board_to_modify.length - 2 # mine is not on bottom row
      # mine is not on bottom left corner
      increment_count(mine_x + 1, mine_y - 1, board_to_modify) unless mine_y <= 1

      increment_count(mine_x + 1, mine_y, board_to_modify)

      # mine is not on bottom right corner
      increment_count(mine_x + 1, mine_y + 1, board_to_modify) unless mine_y >= board_to_modify[mine_x].length - 2
    end

    increment_count(mine_x, mine_y - 1, board_to_modify) unless mine_y <= 1 # mine is not on leftmost column

    # mine is not on rightmost column
    increment_count(mine_x, mine_y + 1, board_to_modify) unless mine_y >= board_to_modify[mine_x].length - 2

  end

  # handles incrementing the mine count of cells on the board
  # cell_x: x coordinates of cell
  # cell_y: y coordinates of cell
  # board_to_modify: the Minesweeper board being transformed
  def self.increment_count(cell_x, cell_y, board_to_modify)

    return if board_to_modify[cell_x][cell_y] == MINE

    if /[[:digit:]]/.match(board_to_modify[cell_x][cell_y].to_s)
      board_to_modify[cell_x][cell_y] = (board_to_modify[cell_x][cell_y].to_i + 1).to_s
    else
      board_to_modify[cell_x][cell_y] = '1'
    end
  end
end
