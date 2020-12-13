require 'http'
require 'launchy'
module Lita
  module Handlers
    class Photo < Handler
      # insert handler code here
      route(
          /photo\s+(.*)/,
          :photo,
          command: true,
          help: { 'photo + anything' => "the photo of this"}
          ) 

      def photo(response)

      	message=response.matches[0][0]
      	response.reply(response.matches[0][0])

		newone = "https://image.baidu.com/search/flip?tn=baiduimage&ie=utf-8&word="+message+"&pn=0"
		document=HTTP.get(newone).body
		document = document.to_s

		data_begin = document.index('"isNeedAsyncRequest"')
		data_end = document.index('fcadData')

		results = document[data_begin, data_end-data_begin]
		regex = /"thumbURL":"[^"]*/

		pictures = []
		counter = 0
		results.scan(regex).each{|m|
					pic=m.to_s
					pictures[counter] = pic[12,pic.size-12]
					counter = counter +1
				}
		response.reply(pictures[rand(29)])
    Launchy.open(pictures[rand(29)])

      end

      Lita.register_handler(self)
    end
  end
end
