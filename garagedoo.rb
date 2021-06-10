# frozen_string_literal: true

require "mini_gpio"
require "erb"
require "uri"

class GarageDoor
  def initialize
    @gpio = MiniGPIO.new
    @toggle_pin = 2
  end

  def call(env)
    method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]

    case [method, path]
    when ["GET", "/"]
      index(env)
    when ["POST", "/toggle"]
      toggle(env)
    else
      not_found(env)
    end
  end

  Dir["views/*.html.erb"].each do |filename|
    basename = File.basename(filename, ".html.erb")
    erb = ERB.new(File.read("views/index.html.erb"))
    erb.def_method(self, "render_#{basename}(env)", filename)
  end

  def index(env)
    [200, {}, [render_index(env)]]
  end

  def toggle(env)
    @gpio.set_mode @toggle_pin, MiniGPIO::Modes::OUTPUT
    @gpio.write @toggle_pin, 0
    sleep 1
    @gpio.set_mode @toggle_pin, MiniGPIO::Modes::INPUT
    [302, { "Location" => "/" }, []]
  end

  def not_found(env)
    [404, {}, ["404: not found"]]
  end
end
