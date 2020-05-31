class Ai
attr_reader :colors_array
  def initialize
    @colors_array = %w[red orange yellow green blue brown pink white black]
  end

  def codemaker(modify_array = {})
    if modify_array.empty?
      @colors_array.shuffle.first(4)
    else
      @colors_array.shuffle.first(4).map.with_index do |element,index|
        modify_array.keys.include?(index) ? element = modify_array[index] : element 
      end
    end
  end

  def codecracker(code,feedback)
    puts feedback.values
    puts "------"
    codemaker(feedback.map{|x,y| [x, y = code[x]]}.to_h)
  end
end