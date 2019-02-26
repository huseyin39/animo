require 'fastimage'

# Class which handles Move log file
class Move
  OUTPUT_JS_FILE = 'output.js'.freeze

  # Constructor
  # number_lines = number of lines dedicated to the code_generator // to be done by Main
  # x, y = initial position
  def initialize(number_lines, path_to_SVG_FILE, window_width: 1000, window_height: 600, x: 0, y: 0)
    @number_lines = number_lines
    @x = x
    @y = y
    @window_width = window_width
    @window_height = window_height
    @path_svg = path_to_SVG_FILE
    @svg_width = nil
    @svg_height = nil
  end



  def resize_svg
    puts @path_svg
    size = FastImage.size(@path_svg)
    puts size
    rate_width = @window_width.to_f / (20 * size[0])
    rate_height = @window_height.to_f / (20 * size[1])

    rate = [rate_height, rate_width].max

    @svg_width = (size[0] * rate).round
    @svg_height = (size[1] * rate).round
    puts @svg_width, @svg_height
  end



  def angle_compute(x1, y1, x2, y2)
    length0 = (x1 - @x)**2 + (y1 - @y)**2
    length1 = (x2 - x1)**2 + (y2 - y1)**2
    length2 = (x2 - @x)**2 + (y2 - @y)**2

    angle = length0 - length1 + length2
    angle /= (2 * length0 * length2)
    angle = Math.acos(angle)
    return angle
  end


  def write_lines(file)
    (0..@number_lines-1).each do |i|
      a = i * 10
      angle = 90 * i
      file.write("image.moveToAndRotation(#{a}, #{angle});\n")
    end

  end


  # Method which handles the main process to create the JavaScript file
  def main
    #Initialize the file
    file = File.open(OUTPUT_JS_FILE, 'w+')
    file.write("import {Move} from './move.js';\n\n")
    file.write("var image = new Move('#{@x}' ,'#{@y}', '#{@path_svg}', #{@window_width}, #{@window_height},
                    '#{@svg_width}', '#{@svg_height}');\n\n")

    #handle animations
    write_lines(file)

  rescue IOError => e
    puts 'Error occurred when creating a new file'
    puts e
  ensure
    file.close unless file.nil?
  end

end

path = "compiler/test_files/dessin.svg"

a = Move.new(10, path, window_width: 1000, window_height: 600, x: 500, y: 300)
a.resize_svg
a.main
