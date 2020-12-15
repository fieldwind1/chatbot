require 'pathname'

module Lita
  module Handlers
    class Cyjl < Handler
      # insert handler code here
      # route(/example/i, command: true) do |response|
      #   response.reply(render_template("example"))
      #   puts render_template("chengyu")




      route(
          /jielong\s+(.*)/,
          :jl,
          command: true,
          help: { 'jielong 成语' => '接龙成语'}
          ) 
      	def jl(response)
      		type = read_administer(6)
          	if type[0] == "0"
	      		# 读取输入内容
	      		awsl=response.matches[0][0]
	      		# 读取成语库
	      		data = render_template("chengyu")
	      		# 准备筛选
	      		regex = /\n.*/ 
	      		cheat = 0
	      		datas = []
	      		counter1 = 0
	      		data.scan(regex).each{|m|
	      			if(m.index(awsl[awsl.size-1,2]) == 1)
						datas[counter1] = m
						counter1=counter1+1
					end
					if(m.index(awsl) == 1)
						cheat = 1
					end
					
	      		}
	      		if (counter1==0)
	      			response.reply("你击败我了")
	      		else
		      		if(cheat==1)
		      			response.reply(datas[rand(counter1-1)])
		      		else 
		      			response.reply("请输入成语")
		      		end
		      	end
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
