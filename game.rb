require './ai'
require './player'
class CheckColors
  def initialize(initial_colors)
    @initial_colors = initial_colors
  end
  def current_state(player_pick)
    console_feedback = []
    duplicates = find_duplicates(player_pick)
    player_pick.each_with_index do |element,index|
      case
      when @initial_colors[index] == element then console_feedback << COLOR_AND_POS
      when duplicates.include?(element) then next
      when @initial_colors.include?(element) then console_feedback << COLOR_ONLY
      end
    end
    if console_feedback.select{|txt| txt == COLOR_AND_POS}.length == 4 
      puts "The code was #{@initial_colors.join("-")}"
      puts "Codecracker has won!!! Congratulations"
      won = true
    else
      puts console_feedback
    end
  end

  private

  COLOR_AND_POS = "One of your guesses is correct both in position and color"
  COLOR_ONLY = "One of your guesses is correct in color but on the wrong position"
  def find_duplicates(array)
    duplicates = Hash.new(0)
    array.each do |element|
      duplicates[element] += 1
    end
    duplicates.select{ |key,val| key if val > 1}.keys
  end
end

puts "Welcome to mastermind game"
puts "Please input your role (codemaker/codecracker)"
role = gets.chomp.downcase
  until role == "codemaker" || role == "codecracker" do
    puts "Choose between |codemaker| and |codecracker|"
    role = gets.chomp.downcase
  end

computer = Ai.new
computer_pick = computer.auto_pick_colors
p computer_pick
colors_check = CheckColors.new(computer_pick)

puts "Available colors to choose from are: [#{Codemaker.get_colors.join(", ")}]"
for i in 1..13
  if i == 13 # the game is set up for 12 rounds so 13th round without code cracked equals to codecracker's loss 
    puts "Codecracker lost. Codemaker made the code too hard"
    break
  end
  puts "Please type four different colors (dash-separated)"
  player_pick = gets.chomp.downcase.split("-")
    until player_pick.length == 4 do
      puts "Please type four different colors (dash-separated)"
      player_pick = gets.chomp.downcase.split("-")
    end
  break if colors_check.current_state(player_pick) == true
end