require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'
require_relative 'flash'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = { })
    @request = req
    @response = res
    @params = Params.new(req, route_params)

    @already_rendered = false
    @response_built = false
  end

  def flash
    @flash ||= Flash.new(@request)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    @response.status = 302
    @response.header['location'] = url

    session.store_session(@response)

    @response_built = true
  end

  def render_content(body, content_type)
    @response.content_type = content_type
    @response.body = body

    session.store_session(@response)

    @already_rendered = true
  end

  def response_built?
    @response_built
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    file_name = "views/#{controller_name}/#{template_name}.html.erb"

    file = File.read(file_name)
    template = ERB.new(file)

    body = template.result(binding)
    render_content(body, content_type)
  end

  def invoke_action(action_name)
    self.send(action_name)
    render(action_name) unless already_rendered?
  end
end
