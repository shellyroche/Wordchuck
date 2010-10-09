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
  class Client
    class << self
      def get_locales
        rh = submit_request('/v1/project/locales')
        yield(rh) if (not rh.nil?) && block_given?
        rh
      end

      def get_locale(locale)
        rh = submit_request("/v1/project/content/#{locale}")
        yield(rh) if (not rh.nil?) && block_given?
        rh
      end

      protected
      def submit_request(rs)
        rh = nil
        begin
          rsce = RestClient::Resource.new(Wordchuck.configuration.api_host_url)
          resp = rsce["#{rs}?api_key=#{Wordchuck.configuration.project_key}"].get
          case resp.code
          when 200
            rh = JSON.parse(resp.body)
            raise Wordchuck::Error, "A fatal Wordchuck API problem -> [#{rh['status']['message']}]." unless rh['status']['code'] == 200
          end

        ## We have some ideas for error reporting back to us automatically, but we will see when we can get to it,
        ## after adding lots of other cool stuff first.

        rescue JSON::ParserError
          raise Wordchuck::Error, "Bad JSON! [#{resp.body}]"
        rescue RestClient::InternalServerError
          raise Wordchuck::Error, "There was a fatal and server error at wordchuck.com of an unknown nature. Stopped."
        end
        rh
      end
    end
  end
end
