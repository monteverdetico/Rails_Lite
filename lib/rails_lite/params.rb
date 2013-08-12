require 'uri'

class Params
  def initialize(req, route_params)
    @req, @route_params = req, route_params
    @params = {}

    parse_www_encoded_form(req.query_string) if req.query_string
    parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    params = URI.decode_www_form(www_encoded_form, enc=Encoding::UTF_8)
    (0...params.count).each do |i|
      key = params[i].first
      value = params[i].last
      @params[key] = value
    end
  end

  def parse_key(key)
    parsed_keys = key.gsub(/\W/, " ").split(" ")
    parsed_keys
  end
end
