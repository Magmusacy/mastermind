class Codemaker
  @@colors_array = %w[red orange yellow green blue brown pink white black]
  def auto_pick_colors
    @@colors_array.shuffle.first(4)
  end
  def self.get_colors
    @@colors_array
  end
end