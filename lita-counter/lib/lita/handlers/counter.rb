module Lita
  module Handlers
    class Counter < Handler
      # insert handler code here
      	# route(
      	# 	/^shuang\s+(\d+)$/i,
      	# 	:respond_with_double,
      	# 	command: true,
      	# 	help: { 'double NNN' => 'prints N+N'}
      	# 	)
        route(
          /count\s+(\d+\W+\d)/,
          :respond_with_count,
          command: true,
          help: { 'count 算式' => '答案'}
          ) 
      	def respond_with_count(response)
          type = read_administer(5)
          if type[0] == "0"
      	   
            data=response.matches[0][0]

            if(data["+"]=="+")
              data1=data.split("+")[0]
              data2=data.split("+")[1]
              data1=data1.to_f
              data2=data2.to_f
              result=data1+data2
              result="%.2f" % result
              
            elsif (data["-"]=="-")
              data1=data.split("-")[0]
              data2=data.split("-")[1]
              data1=data1.to_f
              data2=data2.to_f
              result=data1-data2
              result="%.2f" % result
              
            elsif (data["*"]=="*")
              data1=data.split("*")[0]
              data2=data.split("*")[1]
              data1=data1.to_f
              data2=data2.to_f
              puts data1*data2
              result=data1*data2
              result="%.2f" % result
              
              
            elsif (data["/"]=="/")
              data1=data.split("/")[0]
              data2=data.split("/")[1]
              data1=data1.to_f
              data2=data2.to_f
              result=data1/data2
              result="%.2f" % result
            end
            response.reply(result)
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
