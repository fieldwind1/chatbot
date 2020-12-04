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
          /count\s+(.+)/,
          :respond_with_count,
          command: true,
          help: { 'double N' => 'prints N+N'}
          ) 
      	def respond_with_count(response)

      	   
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
      	end

      	# def double_number(n)
      	# 	n+n+n
      	# end
      Lita.register_handler(self)
    end
  end
end
