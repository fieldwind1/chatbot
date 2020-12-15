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
        type = read_administer(4)
        if type[0] == "0"
        	data = response.matches[0][0]
          data = data.to_i
          response.reply("已经接受闹钟的消息，将会在#{data}秒后提醒您") 
        	after(data) { |timer| 
        		response.reply("Hello, #{data} seconds later!") 
  			 	}
        else
          response.reply("该功能已经被关闭，请进入管理员模式打开该功能")
        end

      end

      def read_administer(q)
        address_add = ''
            address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

            regex = "/chatbot-[^.]*/"

            Dir.entries(File.join(address,"")).each {|e|

             if(e.index('bot')==4)
              address_add = address_add + e.to_s

            end
            }

            address_new = address + address_add + "/lita-test/administer.txt"
            arr = IO.readlines(address_new)

            return arr[q]
      end

      Lita.register_handler(self)
    end
  end
end
