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

module Wordchuck
  class Configuration
    attr_accessor :project_key, :quiet, :backups, :ssl

    API_HOSTNAME = "www.wordchuck.com"
    API_PROJECT_KEY_LENGTH = 18

    def initialize
      @project_key = nil
      @quiet = false
      @backups = false
      @ssl = false
    end

    def has_project_key?
      (not @project_key.nil?) && @project_key.is_a?(String) && @project_key.length == API_PROJECT_KEY_LENGTH
    end
    def quiet?
      @quiet
    end
    def backups?
      @backups
    end
    def ssl?
      @ssl
    end

    def api_host_url
      ssl? ? "https://#{API_HOSTNAME}" : "http://#{API_HOSTNAME}"
    end
  end
end
