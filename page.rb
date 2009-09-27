require 'rubygems'
require 'reggieb'

class Page

  attr_accessor :mode, :color
  
  def html
    %Q{
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
          <title>2RGB :: Convert Hex to RGB and RGB to Hex</title>
          <meta name="description" content="Easily convert hexadecimal colors to RGB colors and RGB colors to hexadecimal colors." />
          <link rel="stylesheet" type="text/css" href="/stylesheets/reset.css" />
          <link rel="stylesheet" type="text/css" href="/stylesheets/style.css" />
          <link rel="icon" type="image/png" href="/images/favicon.png" />
        </head>
        <body>
          <div class="container">
            <h1><a href="/">2RGB</a></h1>
            <h2>an rgb &harr; hex color converter</h2>
            <form action="/index.html" method="post">
              <label for="color">rgb or hex:</label>
              <input type="text" name="color" />
              <input type="submit" value="convert" />
            </form>
            #{results}
          </div>
        </body>
      </html>
    }
  end
  
  def results
    return "" unless mode == :post
    result = convert(color)
    if result
      rgb, hex = result
      %Q{
        <div id="results">
          #{rgb} <span id="arrow">&harr;</span> #{hex}
        </div>
      }
    else
      error_message
    end
  end
  
  def convert(color)
    begin
      result = ReggieB.convert(color)
    rescue
      # this error condition happens if the color is poorly formatted or missing
      return nil
    end
    if result.is_a? Array # the color was hex and the result was [r, g, b]
      rgb = "rgb(#{result[0]}, #{result[1]}, #{result[2]})"
      # we convert it back to hex to get it into a predictable hex format
      hex = ReggieB.convert(rgb)
    else # the color was rgb and the result was hex
      hex = result
      # we convert it back to rgb to get it into a predictable rgb format
      result = ReggieB.convert(hex)
      rgb = "rgb(#{result[0]}, #{result[1]}, #{result[2]})"
    end
    # convert it from the hex format of 0xffffff to #ffffff
    hex = '#' + hex.reverse.chop.chop.reverse
    [rgb, hex]
  end
  
  def error_message
    %Q{
      <div id="results">
        <div id="error">
          I did not understand that color format.  Here are some color
          formats I do understand:
          <ul>
            <li>rgb(255, 255, 255)</li>
            <li>255, 255, 255</li>
            <li>255 255 255</li>
            <li>#FFFFFF</li>
            <li>#ffffff</li>
            <li>#fff</li>
            <li>0xffffff</li>
            <li>ffffff</li>
          </ul>
        </div>
      </div>
    }
  end

end
