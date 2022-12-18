class Game
  def initialize
    @turns_left = 12
  end
  
  def play
    puts "Guess (1) or Create (2)?"
    choice = gets
    loop do
      break if choice.match(/^[12]$/)
      puts "Guess (1) or Create (2)?"
      choice = gets
    end
    @mode = choice.strip.to_i
    if @mode == 1
      random_code
      human_guess
    else
      puts "Enter 4 digits between 1 to 6:"
      user_code = gets
      loop do
        break if user_code.match(/^[1-6][1-6][1-6][1-6]$/)
        puts "Enter 4 digits between 1 to 6:"
        user_code = gets
      end
      set_code(user_code.strip)
      computer_guess
    end
  end

  private

  def random_code
    @code = "#{rand(1..6)}#{rand(1..6)}#{rand(1..6)}#{rand(1..6)}"
  end

  def set_code(code)
    @code = code
  end

  def human_guess
    win = false
    while @turns_left > 0 && !win
      puts "Turns left: #{@turns_left}"
      puts "Enter your guess of 4 digits between 1 to 6:"
      user_guess = gets
      loop do
        break if user_guess.match(/^[1-6][1-6][1-6][1-6]$/)
        puts "Enter your guess of 4 digits between 1 to 6:"
        user_guess = gets
      end
      result = checker(user_guess.strip)
      puts "#{result[0]} black, #{result[1]} white"
      if result[0] == 4
        win = true
        puts "You win! Code: #{@code}"
      end
      @turns_left -= 1
    end
    if !win
      puts "You lose! Code: #{@code}"
    end
  end

  def computer_guess
    win = false
    possibilities = all_possibilities
    while @turns_left > 0 && !win
      puts "Turns left: #{@turns_left}. Possibilities: #{possibilities.size}"
      guess = possibilities.sample
      puts "Computer guessed: #{guess}"
      result = checker(guess)
      puts "#{result[0]} black, #{result[1]} white"
      if result[0] == 4
        win = true
        puts "Computer win! Code: #{@code}"
      else
        possibilities.delete(guess)
        possibilities = possibilities.select{ |n| checker(guess,n)==result }
      end
      @turns_left -= 1
    end
    if !win
      puts "Computer lose! Code: #{@code}"
    end
  end

  def all_possibilities
    result = []
    (1..6).each { |a| 
      (1..6).each { |b| 
        (1..6).each { |c| 
          (1..6).each { |d| 
            result.push("#{a}#{b}#{c}#{d}") 
          }
        }
      }
    }
    result
  end


  def checker(guess, code = @code)
    black = 0
    white = 0
    code_array = code.split("")
    guess_array = guess.split("")
    for i in (0..3).to_a.reverse do
      if code[i] == guess[i]
        black += 1
        code_array.delete_at(i)
        guess_array.delete_at(i)
      end
    end
    guess_array.each{ |val|
      if code_array.include? val
        white += 1
        code_array.delete_at(code_array.index(val))
      end
    }
    return [black, white]
  end

end

game = Game.new
game.play