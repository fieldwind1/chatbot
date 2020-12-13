require 'launchy'
module Lita
  module Handlers
    class Clock < Handler
      # insert handler code here
      route(
          /clock\s+(.+)/,
          :test_way,
          command: true,
          help: { 'clock x' => '计时x秒后会发送消息提示'}
          ) 

      def test_way(response)
      	data = response.matches[0][0]
        response.reply("已经接受闹钟的消息，将会在#{}秒后提醒您") 
      	after(data.to_i) { |timer| 
      		response.reply("Hello, #{data.to_i} seconds later!") 
			# Launchy.open("http://wx1.sinaimg.cn/bmiddle/0065btHFgy1gkwr85y64og302s02smx0.gif")
      	}
        


       
      end
      Lita.register_handler(self)
    end
  end
end
