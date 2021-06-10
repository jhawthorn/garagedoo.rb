# frozen_string_literal: true

#require "mini_gpio"

class GarageDoor
  def initialize
  end

  def call(env)
    method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]

    case [method, path]
    when ["GET", "/"]
      index
    else
      not_found
    end
  end

  def index
    [200, {}, ["HELLO WORLD"]]
  end

  def not_found
    [404, {}, ["404: not found"]]
  end
end
