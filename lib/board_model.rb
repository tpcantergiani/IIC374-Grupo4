# frozen_string_literal: true

require_relative './observer/observable'
require 'matrix'

# Board class that inherets from Observable class
class Board < Observable
  attr_accessor :height, :width

  def initialize
    super

    @height = 3  # TO DO: ask the user which heigth (s)he wants
    @width = 3  # TO DO: ask the user which width (s)he wants
    @bombs = 2  # TO DO: ask the user for difficulty level

    # Indicates if the box is visible for the player or not.
    @state_matrix = Array.new(@height) {Array.new(@width, '0')}

    # Indicates the type of the box (may be unknown for the player).
    @hidden_matrix = Array.new(@height) {Array.new(@width, '-')}

    fill_board
  end

  def inside_board(row, col)
    if row < 0
      false
    elsif row >= @height
      false
    elsif col < 0
      false
    elsif col >= @width
      false
    else
      # puts "#{row},#{col} está dentro del tablero."
      true
    end
  end

  def box_with_bomb(row, column)
    @hidden_matrix[row][column] === '*'
  end

  def fill_board_with_bombs
    # [*May take a long while because of randomness.]
    total_bombs = 0
    while total_bombs < @bombs
      row = rand(@height)
      column = rand(@width)

      if @hidden_matrix[row][column] != '*'
        @hidden_matrix[row][column] = '*'
        total_bombs += 1
      end
    end
  end

  def fill_board_with_numbers
    (0..@height-1).each do |row|
      (0..@width-1).each do |column| 
        bombs_surrounding = bombs_in_surroundings(row, column)
        if @hidden_matrix[row][column] != '*'
          @hidden_matrix[row][column] = bombs_surrounding
        end
      end
    end
  end

  def bombs_in_surroundings(row, col)
    # puts "Revisando (#{row},#{col})"
    bombs_surrounding = 0
    (row-1..row+1).each do |row_searched|
      (col-1..col+1).each do |col_searched|
        if (row_searched == row) && (col_searched == col)
          next
        end
        if inside_board(row_searched, col_searched) && box_with_bomb(row_searched, col_searched)
          bombs_surrounding += 1
        end
      end
    end
    # puts bombs_surrounding
    # puts
    bombs_surrounding
  end

  def fill_board
    # Fills the board with bombs and numbers indicating how many bombs
    # there are surrounding that square.
    fill_board_with_bombs
    fill_board_with_numbers
  end

  def symbol_at(row, column)
    # If the box is visible, returns the type of the box. if not, returns a 
    # string with a space.
    if @state_matrix[row][column] === 1
      @hidden_matrix[row][column]
    else
      ' '
    end
  end

  def mark(row, column)
    # Changes the state of a box to visible for the player.
    if @state_matrix[row][column] === '0'
      @state_matrix[row][column] = '1'
    else
      print 'Elige una nueva posición, dado que la elegida no es válida.'
    end
    notify_all
  end

  def winner
  end

  def bomb_explosion
  end
end
