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
        response.reply(response.matches[0][0])

        Dir.entries(File.join("/app/vendor/bundle/ruby/2.6.0/bundler/gems/","")).each {|e|

         puts e
        }
      end
      Lita.register_handler(self)
    end
  end
end
