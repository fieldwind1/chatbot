module Lita
  module Handlers
    class Test < Handler
    	flag=1
      # insert handler code here
      route(
          /count\s+(.+)/,
          :test_way,
          command: true,
          help: { 'double N' => 'prints N+N'}
          ) 

      def test_way(response)
      	aFile = File.new("data.txt", "a+:UTF-8")
      end
      Lita.register_handler(self)
    end
  end
end
