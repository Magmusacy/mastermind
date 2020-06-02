class Ai
attr_reader :colors_array
  def initialize
    @colors_array = %w[red orange yellow green blue brown pink white black]
    @available_indexes = [0,1,2,3]
  end

  def codemaker(colors_good_pos = {}, colors_wrong_pos = {})

  @available_indexes -= colors_good_pos.keys
    if colors_good_pos.empty?
      @array = @colors_array.shuffle.first(4)
    end

    unless colors_good_pos.empty?
      @array = @colors_array.shuffle.first(4).map.with_index do |element,index|
          colors_good_pos.keys.include?(index) ? element = colors_good_pos[index] : element 
      end
    end

    unless colors_wrong_pos.empty? # include color from specified variable in another computer's guess but on different position
      @array = @array.each_with_index do |element,index| 
        colors_wrong_pos.keys.include?(index) ? @array[(@available_indexes - [index]).first] = colors_wrong_pos[index] : next
      end
    end

    @array 
  end

  def codecracker(code,feedback)
    puts feedback.values
    puts "------"
    color_good_position = feedback.select{ |k,v| v.split[-2] == "correct"}.map{ |k,v| [k, v = code[k]]}.to_h # correct color on correct position
    color_wrong_position = feedback.select{ |k,v| v.split[-2] == "wrong"}.map{ |k,v| [k, v = code[k]]}.to_h # correct color on wrong position
    codemaker(color_good_position, color_wrong_position)
  end
end