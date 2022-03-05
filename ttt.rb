require "pry-byebug"
require "colorize"

class Field
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

class Game < Field
  def initialize
    @finished_game = false
    @fields = []
    @who_won
    9.times { |x| @fields[x] = Field.new(x + 1) }
  end

  public

  def display_grid
    print "
                |       |
            #{@fields[0].value}   |   #{@fields[1].value}   |   #{@fields[2].value}
         _______|_______|_______
                |       |
            #{@fields[3].value}   |   #{@fields[4].value}   |   #{@fields[5].value}
         _______|_______|_______
                |       |
            #{@fields[6].value}   |   #{@fields[7].value}   |   #{@fields[8].value}
                |       |

        "
  end

  def get_input
    print "     Please choose your field: "
    # byebug
    input = gets.chomp.downcase.to_i
    if (input.between?(1, 9))
      if (@fields[input - 1].value == "O".green || @fields[input - 1].value == "X".red)
        return "Wrong input!"
      else
        return input
      end
    else
      return "Wrong input!"
    end
  end

  def computer_play
    computer_pick = Random.rand(1..9).floor
    while (@fields[computer_pick - 1].value.class == String) do
      computer_pick = Random.rand(1..9).floor
    end
    computer_pick
  end

  def check?
    i = 0
    z = 2

    # Check rows
    loop do
      # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      row = @fields[(i..z)].all? { |el|
        el.value == "O".green
      } || @fields[(i..z)].all? { |el|
             el.value == "X".red
           }
      if (row == true)
        if (@fields[i].value == "O".green)
          @who_won = "You won!"
        elsif (@fields[i].value == "X".red
              )
          @who_won = "You lose!"
        end
        return row
      end
      i += 3
      z += 3
      break if i == 9
    end

    i = 0
    z = 6

    # Check columns
    loop do
      column = @fields[(i..z).step(3)].all? { |el| el.value == "O".green } || @fields[(i..z).step(3)].all? { |el|
        el.value == "X".red
      }
      if (column == true)
        if (@fields[i].value == "O".green)
          @who_won = "You won!"
        elsif (@fields[i].value == "X".red
              )
          @who_won = "You lose!"
        end
        return column
      end
      i += 1
      z += 1
      break if i == 3
    end

    i = 0
    z = 8
    c = 4
    count = 0
    # Check diagonals
    loop do
      diagonal = @fields[(i..z).step(c)].all? { |el| el.value == "O".green } || @fields[(i..z).step(c)].all? { |el|
        el.value == "X".red
      }
      if (diagonal == true)
        if (@fields[4].value == "O".green)
          @who_won = "You won!"
        elsif (@fields[4].value == "X".red
              )
          @who_won = "You lose!"
        end
        return diagonal
      end
      i = 2
      z = 6
      c = 2
      count += 1
      break if count == 2
    end

    if (@fields.none? { |d| d.value.class == Integer })

      @who_won = "It's a Draw!"
      return true
    end
    return false
  end

  def round
    check_player_win = false
    pick = get_input
    while (pick == "Wrong input!") do
      puts "      #{pick}"
      pick = get_input
    end
    @fields[pick - 1].value = "O".green

    check_player_win = check?

    if (check_player_win == false && @fields.any? { |d| d.value.class == Integer })
      @fields[computer_play - 1].value = "X".red
    end

    @finished_game = check?
    display_grid
  end

  def play_game
    until (@finished_game) do
      round
    end

    puts @who_won
  end
end

puts "\n    Welcome to the Tic Tac Toe Game!!"

new_game = Game.new

print "
                |       |
            1   |   2   |   3
         _______|_______|_______
                |       |
            4   |   5   |   6
         _______|_______|_______
                |       |
            7   |   8   |   9
                |       |

"
new_game.play_game
