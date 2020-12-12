require 'pathname'
module Lita
  module Handlers
    class Cyjl < Handler
      # insert handler code here
      route(
          /jielong\s+(.+)/,
          :jl,
          command: true,
          help: { 'jielong 成语' => '相应的成语'}
          ) 
      	def jl(response)

      		mulu1 =  Pathname.new(File.dirname(__FILE__)).realpath
      		mulu2 =  File.dirname(__FILE__)

      		response.reply(mulu1)
      		response.reply(mulu2)

      		awsl=response.matches[0][0]
      		cheat=1
			aFile = File.open("test.txt", "r:UTF-8")
			datas = []
			data = []
			conter1=0
			aFile.each_line do |line|
				datas[conter1]=line
				conter1=conter1+1
			end
			conter1=0
			for w in datas 
				if(w.index(awsl[awsl.size-1,awsl.size])==0)
					data[conter1]=w
					conter1=conter1+1
				end
				if(w.index(awsl)==0)
					cheat=0
				end
			end

			if(cheat==1)
				response.reply("请输入成语")
			else
				response.reply(data[rand(conter1-1)])
			end
      	end
      Lita.register_handler(self)
    end
  end
end
