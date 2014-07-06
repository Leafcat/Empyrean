# templaterenderer.rb - renders a ERB template
#
# This file is part of RubyTwitterStats 
# Copyright (C) 2014 nilsding
# Copyright (C) 2014 pixeldesu
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

require 'erb'

class TemplateRenderer
  
  ##
  # Initializes a new TemplateRenderer.
  # 
  # template: The template to use (i.e. not the file name)
  # parsed_tweets: The dict that gets returned by TweetParser::merge_parsed
  def initialize(template, parsed_tweets)
    @template = template
    @parsed = parsed_tweets
  end
  
  ##
  # Renders @template.
  def render
    mentions = mentions_erb
    hashtags = hashtags_erb
    clients = clients_erb
    erb = ERB.new @template
    erb.result binding
  end
  
  private
    ##
    # Returns an array with the mentions which can be easily used within ERB.
    def mentions_erb
      retdict = {
        top10: [],
        nottop: []
      }
      top10 = @parsed[:mentions].slice(0, 10) # top 10 mentions
      top10.each do |mention|
        retdict[:top10] << mention[1]
      end
      
      nottop = @parsed[:mentions].slice(11, 20) # not in the top 10
      unless nottop.nil?
        nottop.each do |mention|
          mention[1].delete(:example)
          retdict[:nottop] << mention[1]
        end
      end
      
      retdict
    end
    
    ##
    # Returns an array with the hashtags which can be easily used within ERB.
    def hashtags_erb
      retdict = {
        top10: [],
        nottop: []
      }
      top10 = @parsed[:hashtags].slice(0, 10) # top 10 mentions
      top10.each do |hashtag|
        retdict[:top10] << hashtag[1]
      end
      
      nottop = @parsed[:hashtags].slice(11, 20) # not in the top 10
      unless nottop.nil?
        nottop.each do |hashtag|
          hashtag[1].delete(:example)
          retdict[:nottop] << hashtag[1]
        end
      end
      
      retdict
    end
    
    ##
    # Returns an array with the clients which can be easily used within ERB.
    def clients_erb
      retdict = {
        top10: [],
        nottop: []
      }
      top10 = @parsed[:clients].slice(0, 10) # top 10 clients
      top10.each do |client|
        retdict[:top10] << {
          name: client[1][:name],
          url: client[1][:url],
          count: client[1][:count],
          percentage: (client[1][:count] * 100 / @parsed[:tweet_count].to_f).round(2)
        }
      end
      
      nottop = @parsed[:clients].slice(11, 20) # not in the top 10
      unless nottop.nil?
        nottop.each do |client|
          client[1].delete(:example)
          retdict[:nottop] << {
            name: client[1][:name],
            url: client[1][:url],
            count: client[1][:count],
            percentage: (client[1][:count] * 100 / @parsed[:tweet_count].to_f).round(2)
          }
        end
      end
      
      retdict
    end
end

# kate: indent-width 2