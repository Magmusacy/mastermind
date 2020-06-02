require './ai'
class CheckColors
  attr_accessor :initial_colors, :role
  def initialize(initial_colors, role)
    @initial_colors = initial_colors
    @role = role
  end

  def current_state(picked_colors)

    console_feedback = {}
    duplicates = find_duplicates(picked_colors)
    picked_colors.each_with_index do |element,index|
      case
      when initial_colors[index] == element then console_feedback[index] = "[#{index+1}]: #{COLOR_AND_POS}" 
      when duplicates.include?(element) then next
      when initial_colors.include?(element) then console_feedback[index] = "[#{index+1}]: #{COLOR_ONLY}"
      end
    end
    if console_feedback.values.select{ |txt| txt[5..-1] == COLOR_AND_POS }.length == 4 
      puts "The code was [#{initial_colors.join("-")}]"
      true
    else
      role == "codecracker" ? console_feedback.values : console_feedback
    end
  end

  private

  COLOR_AND_POS = "Correct color and correct position"
  COLOR_ONLY = "Correct color on the wrong position"

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

colors_check = CheckColors.new(chosen_colors,role)

puts "Available colors to choose from are: [#{computer.colors_array.join(", ")}]"

i = 1
while i < 13
  if role == "codecracker"
    code = gets.chomp.downcase.split("-")
      until code.length == 4 do
        puts "Please type four different colors (dash-separated)"
        code = gets.chomp.downcase.split("-")
      end
    puts colors_check.current_state(code)
  else
    code ||= computer.codemaker
    code = computer.codecracker(code, colors_check.current_state(code))
    puts "Computer's guess is #{code}."
  end
if colors_check.current_state(code) == true
  puts "Codecracker has won in #{i} rounds! Congratulations."
  break
end
if i == 12
  puts "The code was [#{colors_check.initial_colors.join("-")}]"
  puts "The code was too hard for codecracker to crack. Codemaker won this game!"
end
i += 1
end