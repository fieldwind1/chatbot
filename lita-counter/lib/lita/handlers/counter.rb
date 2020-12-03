module Lita
  module Handlers
    class Counter < Handler
      # insert handler code here
      	route(
      		/^shuang\s+(\d+)$/i,
      		:respond_with_double,
      		command: true,
      		help: { 'double NNN' => 'prints N+N'}
      		)
      	def respond_with_double(response)

      		n=response.match_data.captures.first
      		n=Integer(n)
      		response.reply "#{n} +#{n} = #{double_number n}"
      	end

      	def double_number(n)
      		n+n+n
      	end
      Lita.register_handler(self)
    end
  end
end
