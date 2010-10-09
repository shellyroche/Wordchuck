##
# Copyright (c) Wordchuck Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

require 'rubygems'
require 'active_support'
require 'json'
require 'rest-client'
require 'human_hash'

module Wordchuck
  class << self
    #
    # = Wordchuck Configuraton
    #
    # Call the configure method within a application configuration initializer to set your project key (and other goodies):
    #   Wordchuck.configure do |chuck|
    #     chuck.project_key = 'from.wordhuck.com.members.area'
    #     chuck.quiet = true
    #   end
    #

    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
    def has_project_key?
      self.configuration ||= Configuration.new
      configuration.has_project_key?
    end

    def no_project_key
      "No project key configured. A project key is needed to identify the project in question with the Wordchuck API."
    end
    def api_failure
      "There was an unexpected API response code. Not HTTP 200. Failed."
    end
  end

  class Error < RuntimeError
  end
end

require 'wordchuck/configuration'
require 'wordchuck/client'
require 'wordchuck/chucker'
require 'wordchuck/railtie' if defined?(Rails::Railtie)
