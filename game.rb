require './ai'
require './player'
class CheckColors
  attr_accessor :initial_colors
  def initialize(initial_colors)
    @initial_colors = initial_colors
  end

  def current_state(picked_colors)

    console_feedback = {}
    duplicates = find_duplicates(picked_colors)
    picked_colors.each_with_index do |element,index|
      case
      when initial_colors[index] == element then console_feedback[index] = COLOR_AND_POS 
      when duplicates.include?(element) then next
      when initial_colors.include?(element) then console_feedback[index] = COLOR_ONLY
      end
    end
    if console_feedback.values.select{ |txt| txt == COLOR_AND_POS }.length == 4 
      puts "The code was #{initial_colors.join("-")}"
      puts "Codecracker has won! Congratulations."
      won = true
    else
      console_feedback
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

if role == "codemaker" 
  available_colors = %w[red orange yellow green blue brown pink white black]
  puts "Pick 4 colors from this array (separate each color using dash-):"
  puts "[#{available_colors.join(", ")}]"
  chosen_colors = gets.chomp.downcase.split("-")
    until chosen_colors.all?{ |colors| available_colors.include?(colors)} do # checks if all colors in chosen_colors are included in available_colors
      puts "Something went wrong... Try again"
      chosen_colors = gets.chomp.downcase.split("-")
    end
else 
  chosen_colors = computer.codemaker
end

colors_check = CheckColors.new(chosen_colors)

puts "Available colors to choose from are: [#{Ai.new.colors_array}]"

i = 0
while i < 13
  if role == "codecracker"
    code = gets.chomp.downcase.split("-")
      until code.length == 4 do
        puts "Please type four different colors (dash-separated)"
        code = gets.chomp.downcase.split("-")
      end
  else
    code ||= computer.codemaker
    code = computer.codecracker(code, colors_check.current_state(code))
    puts "Computer's guess is #{code}."
  end
break if colors_check.current_state(code) == true 
puts "The code was too hard for codecracker to crack. Codemaker won this game!" if i == 12
i += 1
end