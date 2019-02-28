require_relative 'useful_methods'

module AnimationInstructions
  class HTMLFileInitialization
    attr_accessor :filename, :window_width, :window_height
    def initialize filename, window_width = 1000, window_height = 600
      @filename = filename
      @window_width = window_width
      @window_height = window_height
    end

    def write
      raise 'abstract method'
    end
  end

  class HTMLFileMove < HTMLFileInitialization
    def initialize  filename, window_width = 1000, window_height = 600
      super(filename, window_width, window_height)
      write
    end

    def write
      begin
        path = File.join(File.dirname(__FILE__ ), "../res/"+@filename+".html")
        file = File.new(path, 'w+')
        string = "<!DOCTYPE html>\n<html>\n<head>\n  <script src=\"../animation/svg.js\"></script>\n  <meta charset=\"UTF-8\">\n</head>\n<body>\n  <svg width=\"#{@window_width}\" height=\"#{@window_height}\" style = \"position: absolute;\">\n    <line x1=\"0\" y1=\"#{@window_height/2}\" x2=\"#{@window_width}\" y2=\"#{@window_height/2}\" style=\"stroke:rgb(255,0,0);stroke-width:2\" />\n    <line x1=\"#{@window_width/2}\" y1=\"0\" x2=\"#{@window_width/2}\" y2=\"#{@window_height}\" style=\"stroke:rgb(255,0,0);stroke-width:2\" />\n    <polyline points=\"0,0 #{@window_width},0 #{@window_width},#{@window_height} 0,#{@window_height} 0,0\"\n    style=\"fill:none;stroke:black;stroke-width:3\" />\n  </svg>\n  <div id=\"drawing\"></div>\n  <script src=\"#{@filename}.js\" type=\"module\"></script>\n</body>\n</html>\n"
        file.write(string)
      ensure
        file.close unless file.nil?
      end
    end
  end

  class HTMLFileChart < HTMLFileInitialization
    def initialize  filename, window_width = 1000, window_height = 600
      super(filename, window_width, window_height)
      write
    end

    def write
      begin
        path = File.join(File.dirname(__FILE__ ), "../res/"+@filename+".html")
        file = File.new(path, 'w+')
        string = "<!DOCTYPE html>\n<html>\n<head>\n  <meta charset=\"UTF-8\">\n  <script src=\"Chart.js\"></script>\n</head>\n<body>\n  <div class=\"chart-container\" style=\"position: absolute; width:#{@window_width}px; height:#{@window_height}px\">\n    <canvas id=\"chart\"></canvas>\n  </div>\n</body>"
        file.write(string)
      ensure
        file.close unless file.nil?
      end
    end
  end

  class ObjectInitialization
    attr_accessor :identifier, :filename, :window_width, :window_height

    def initialize identifier, filename, window_width = 1000, window_height = 600
      @identifier = identifier
      @filename = filename
      @window_width = window_width
      @window_height = window_height
    end

    def write
      raise 'abstract method'
    end
  end

  class MoveInitialization < ObjectInitialization
    def initialize file, identifier, filename, window_width = 1000, window_height = 600
      super(identifier, filename, window_width, window_height)
      write(file)
    end

    def write file
      path = File.join(File.dirname(__FILE__), '../svg_files/' + @filename)
      width, height = resize_svg(path)

      string = "var #{identifier} = draw.image('../svg_files/#{@filename}').size(#{width}, #{height}).cx(#{@window_width/2}).cy(#{@window_height/2});\n"
      file.write(string)
    end
  end

  class ChartInitialization < ObjectInitialization
    def initialize file, identifier, filename, window_width = 1000, window_height = 600
      super(identifier, filename, window_width, window_height)
      write(file)
    end
    #here
  end

  class Instruction
    attr_accessor :duration, :identifier, :parameters

    def initialize duration, identifier, *parameters
      @duration = duration
      @identifier = identifier
      @parameters = parameters
    end

    def write file
      raise 'abstract method'
    end
  end


  class MoveInstruction < Instruction
    def initialize file, duration, identifier, first = nil, *parameters
      super(duration, identifier, parameters)
      if (first.nil?)
        write(file)
      elsif (first == true)
        write_first_line(file)
      else
        write_last_line(file)
      end
    end

    def write file
      distance, angle= @parameters[0]
      string = "#{@identifier}.animate(#{duration}).dx(#{distance}).once(1, function(){#{@identifier}.rotate(-#{angle});}, true);\n"
      file.write(string)
    end

    def write_first_line file
      string = "#{@identifier}.rotate(-#{@parameters[0][0]});\n"
      file.write(string)
    end

    def write_last_line file
      string = "#{@identifier}.animate(#{@duration}).dx(#{@parameters[0][0]});\n"
      file.write(string)
    end
  end
end