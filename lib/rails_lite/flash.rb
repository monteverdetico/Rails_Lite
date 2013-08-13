require 'webrick'

class Flash
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_flash'
        @cookie_value = JSON.parse(cookie.value)
      end
    end

    @cookie_value ||= {}
  end

  def [](key)
    @cookie_value[key]
  end

  def []=(key, val)
    @cookie_value[key] = val
  end

  def reset_flash(response)
    response.cookies.each do |cookie|
      cookie.value = nil if cookie.name == '_rails_lite_flash'
    end
  end

  def store_session(res)
    value = @cookie_value
    session_cookie = WEBrick::Cookie.new('_rails_lite_flash', JSON.dump(value))

    res.cookies << session_cookie
  end

end