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
          help: { 'double N' => 'prints N+N'}
          ) 

      def test_way(response)
      	# aFile = File.new("data.txt", "a+:UTF-8")
       #  aFile.syswrite("ABCDEF")
       #  arr = IO.readlines("data.txt")
       #  puts arr
        # response.reply(response.matches[0][0])

        # Dir.entries(File.join("/app/vendor/bundle/ruby/2.6.0/bundler/gems/","")).each {|e|

        #  puts e
        # }

          # after(5) { |timer| response.reply("Hello, 5 seconds later!") }
          Launchy.open("https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=824241582,259972087&fm=26&gp=0.jpg")


       
      end
      on :loaded, :greet

      def greet(payload)
        robot.send_message(1, "
                   _ooOoo_
                  o8888888o
                  88' . '88
                  (| -_- |)
                  O|  =  |O
               ____|`---'|____

           佛祖保佑      永无BUG
          ")
      end
      Lita.register_handler(self)
    end
  end
end
