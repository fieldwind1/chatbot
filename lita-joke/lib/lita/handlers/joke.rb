module Lita
  module Handlers
    class Joke < Handler
      # insert handler code here

      route(
          /^joke/,
          :joke,
          command: true,
          help: { 'joke' => '讲个笑话'}
          ) 

      def joke(response)
      		type = read_administer(10)
          	if type[0] == "0"
	      		address_add = ''
	            address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

	            regex = "/chatbot-[^.]*/"

	            Dir.entries(File.join(address,"")).each {|e|

	             if(e.index('bot')==4)
	              address_add = address_add + e.to_s

	            end
	            }

	            address_new = address + address_add + "/lita-joke/joke.txt"
	            arr = IO.readlines("address_new")
	            # arr = IO.readlines("joke.txt")
	            response.reply(arr[rand(arr.length)])
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
