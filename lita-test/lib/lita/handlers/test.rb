require 'launchy'
module Lita
  module Handlers
    class Test < Handler
    	flag=1
      # insert handler code here
      route(
          /test\s+(.+)/,
          :test_way,
          command: true,
          help: { 'test' => 'prints N+N'}
          ) 

      def test_way(response)
      	# aFile = File.new("data.txt", "a+:UTF-8")
       #  aFile.syswrite("ABCDEF")
       #  arr = IO.readlines("data.txt")
       #  puts arr
        # response.reply(response.matches[0][0])
        address_add = ''
        address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

        regex = "/chatbot-[^.]*/"

        Dir.entries(File.join(address,"")).each {|e|

         if(e.index('bot')==4)
          address_add = address_add + e.to_s
          puts address_add
        end
        }
        puts address_add
        address_new = address + address_add + "/lita-test/administer.txt"
        arr = IO.readlines(address_new)
        response.reply(arr)
      
      end
      # on :loaded, :greet

      # def greet(payload)
      #   target = Source.new(room: payload[:room])
      #   robot.send_message(target, "
      #              _ooOoo_
      #             o8888888o
      #             88' . '88
      #             (| -_- |)
      #             O|  =  |O
      #          ____|`---'|____

      #      佛祖保佑      永无BUG
      #     ")
      # end
      Lita.register_handler(self)
    end
  end
end
