require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
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

  def store_session(res)
    value = @cookie_value
    session_cookie = WEBrick::Cookie.new('_rails_lite_app', JSON.dump(value))

    res.cookies << session_cookie
  end
end
