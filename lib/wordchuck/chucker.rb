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

##
# The thinking behind this class name for putting the locales in .rb for i18n simple backend ingestion is obvious enough, 
# at least to us:
#   http://www.youtube.com/watch?v=DjGwusHrOtk
##

module Wordchuck
  class Chucker
    class << self
      def generate
        if Wordchuck.has_project_key?
          begin
            puts "Acquiring Locales List [production|development]..." unless Wordchuck.configuration.quiet?
            if locales = Wordchuck::Client.get_locales
              puts "DONE."
              locales['development']['locales'].each do |locale|

                puts "Acquiring Locale for Simple Backend [#{locale['code']}]..." unless Wordchuck.configuration.quiet?
                Wordchuck::Client.get_locale(locale['code']) do |rh|
                  Wordchuck::Chucker.set_locale(locale['code'], rh['content'][locale['code']])
                end

              end
              puts "DONE"
            end
          rescue Wordchuck::Error => error
            puts error.message
          end

        else
          puts Wordchuck.no_project_key end
      end

      def set_locale(locale, content)
        set_locale_in_simple_backend(locale, content)
      end

      protected
      def set_locale_in_simple_backend(locale, content)
        ln = "#{Rails.root}/config/locales/#{locale}.rb"
        File.rename(ln, "#{locale_pathname}.wcbak") if Wordchuck.configuration.backups? && File.exist?(ln)
        File.open(ln, 'w') do |fd|
          set_locale_header(fd, locale)
          set_locale_start(fd, locale)
          fd.write(content.human_inspect)
          set_locale_end(fd)
        end
      end

      private
      def set_locale_header(fd, locale)
        tmps  = "# encoding: UTF-8\n"    
        tmps << "#\n"
        tmps << "# DO NOT EDIT THIS FILE.\n"
        tmps << "# This locale file is auto-generated from the Wordchuck API by the Wordchuck Ruby gem. Any manual\n"
        tmps << "# updates to an rb file will be lost when this file is regenerated. This current file will be only\n"
        tmps << "# versioned once, or discarded.\n"
        tmps << "# http://wordchuck.com\n"
        tmps << "#\n"
        tmps << "##\n\n"
        fd.write(tmps)
      end
      def set_locale_start(fd, locale)
        fd.write("{\n  :'#{locale}' =>\n\n")
      end
      def set_locale_end(fd)
        fd.write("\n}\n\n")
      end
      def move_files_to_old
        ## TBD
      end
    end
  end
end