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
          help: { 'jielong 成语' => '相应的成语'}
          ) 
      	def jl(response)
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
      		if(cheat==1)
      			response.reply(datas[rand(counter1-1)])
      		else
      			response.reply("请输入成语")
      		end
   # #    		cheat=1
			# # aFile = File.open("/test.txt", "r:UTF-8")
			# # datas = []
			# # data = []
			# # conter1=0
			# # aFile.each_line do |line|
			# # 	datas[conter1]=line
			# # 	conter1=conter1+1
			# # end
			# conter1=0
			# for w in datas 
			# 	if(w.index(awsl[awsl.size-1,awsl.size])==0)
			# 		data[conter1]=w
			# 		conter1=conter1+1
			# 	end
			# 	if(w.index(awsl)==0)
			# 		cheat=0
			# 	end
			# end

			# if(cheat==1)
			# 	response.reply("请输入成语")
			# else
			# # 	response.reply(data[rand(conter1-1)])
			# end
			
      	end
      Lita.register_handler(self)
    end
  end
end
