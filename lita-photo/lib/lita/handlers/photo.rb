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
          help: { 'photo 某物' => "关于该事物的图片"}
          ) 

      def photo(response)
        type = read_administer(8)
        if type[0] == "0"

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
