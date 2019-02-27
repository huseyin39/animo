require 'fastimage'
require_relative 'svg_code_generator'

  #Given an svg file, it returns the size of the object regarding the size of the screen(1000,600)
  def resize_svg path
    size = FastImage.size(path)
    rate_width = 1000.to_f / (20 * size[0])
    rate_height = 600.to_f / (20 * size[1])

    rate = [rate_height, rate_width].max

    width = (size[0] * rate).round
    height = (size[1] * rate).round
    return width, height
  end

  def compute_next_parameters *coordinates
    x,y,x1,y1,x2,y2 = coordinates

    length_0 = compute_distance([x,y,x1,y1]) # ||P0P1||
    angle = compute_angle(x1, y1, x2, y2)
    return length_0, angle
  end

  def compute_distance coordinates
    x,y,x1,y1 = coordinates
    distance = Math.sqrt( (x - x1)**2 + (y - y1)**2 )
    return distance
  end

  def compute_angle *coordinates
    x0, y0, x, y = coordinates
    x, y = x-x0, y-y0

    if (x == 0)
      if (y < 0 )
        return -90
      elsif (y > 0)
        return 90
      else
        return nil
      end
    end

    angle = Math.atan(y/x)
    angle = angle*180/Math::PI
    if (angle > 0)
      if (x < 0) #that means y<0 too
        return 180+angle
      else
        return angle
      end
    elsif (angle < 0)
      if (x < 0) #that means y>0
        return 180+angle
      else
        return 360+angle
      end
    else
      return angle
    end
  end