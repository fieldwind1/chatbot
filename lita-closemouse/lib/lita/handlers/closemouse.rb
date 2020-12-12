module Lita
  module Handlers
    class Closemouse < Handler
      # insert handler code here
      em=["gou","","","","",""]
      i=1
      route(/^add\s+(.+)/, :echo2,command: true, help:  " Add Sensitive word " )
      flag=1
      def echo2(response)
      	# if i<6
      		em[i]=response.matches[0][0]
      	# 	i=i+1

      		response.reply("123")
      		# flag=2
        #   response.reply(flag)
      end

      # route(/(.+)/, :echo,command: true, help: { "calender 1997-12" => "Echoes back TEXT." })

      # def echo(response)
      # 	if flag!=2
      # 		response.reply(response.matches)
      # 	end
      # 	# data=response.matches[0][0]
      # 	# 	for j in 0...i

      # 	# 	response.reply(response.matches)
      #   response.reply(flag) 
      # end
      Lita.register_handler(self)
    end
  end
end
