require 'fastimage'

module UsefulMethods
  def resize_svg path
    size = FastImage.size(path)
    rate_width = 1000.to_f / (20 * size[0])
    rate_height = 600.to_f / (20 * size[1])

    rate = [rate_height, rate_width].max

    width = (size[0] * rate).round
    height = (size[1] * rate).round
    return width, height
  end


end