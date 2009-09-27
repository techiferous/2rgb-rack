require 'page'

class App

  def call(env)
    
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response['Content-Type'] = 'text/html'
    
    # Since this is a one-page website, we don't even bother to check the path.

    if request.get? # visiting the page
      page = Page.new
      response.write page.html
    elsif request.post? # pressing the convert button
      page = Page.new
      page.mode = :post
      page.color = request.params["color"]
      response.write page.html
    else
      response.status = 405
      response.write "I'm sorry Dave, I'm afraid I can't do that."
    end
    
    response.finish
    
  end

end
