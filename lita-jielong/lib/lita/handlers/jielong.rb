require 'rubygems'
require 'mechanize'
module Lita
  module Handlers
    class Jielong < Handler
      # insert handler code here
      route(
          /net\s+(.+)/,
          :respond_with_count,
          command: true,
          help: { 'double N' => 'prints N+N'}
          ) 
      	def respond_with_count(response)
      		agent = Mechanize.new
      		page = agent.get('http://geogle.com/')
      		response.reply("happy")
      	end
      Lita.register_handler(self)
    end
  end
end
