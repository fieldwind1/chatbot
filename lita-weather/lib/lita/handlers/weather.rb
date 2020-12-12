require 'http'
require 'rubygems'
require 'mechanize'
module Lita
  module Handlers
    class Weather < Handler
      # insert handler code here
      route(
          /weather(.*)/,
          :weather,
          command: true,
          help: { 'weather + city' => "city's weather"}
          ) 
      def weather(response)
      	message=response.matches[0][0]

      	agent = Mechanize.new
		page = agent.get('http://www.baidu.com/')
		baidu_form = page.form('f')
		if(message.empty?)
			baidu_form.wd = '北京'
		else
			baidu_form.wd = message
		end
		baidu_form.wd = baidu_form.wd+"中国天气预报"
		page = agent.submit(baidu_form)

		page = agent.click(page.link_with(:text => /天气预报/))
		newone = page.uri

		document=HTTP.get(newone).body

		search_result=document.to_s

		data_begin = search_result.index('"7d":[["')
		data_end = search_result.index('"]]}')

		data = search_result[data_begin+7,data_end-data_begin+7]

		date=Array.new(40, 0)
		weather=Array.new(40, 0)
		temper=Array.new(40, 0)
		wind=Array.new(40, 0)
		windp=Array.new(40, 0)

		regex = /".*?,.*?,.*?,.*?,.*?,.*?,[0-9]"/ 
		#0 日期 1 2天气情况 3温度 4风向 5 风力
		counter=0

		cut=Array.new(5, 0)
		data.scan(regex).each{|m|
			detial = m.split(",")
			detial[0][0] = ""
			date[counter] = "time:"+detial[0]
			weather[counter] = "weather:"+detial[2]
			temper[counter] = "temperature:"+detial[3]
			wind[counter] = "wind:"+detial[4]
			windp[counter] = "windpower:"+detial[5]
			counter = counter+1
		}
		counter=0
		time = Time.new
		hour = time.hour
		a=date[0][10,2]

		response.reply(hour)

		while a.to_i<hour
			counter=counter+1
			a=date[counter][10,2]
			response.reply(hour)
			response.reply(counter)
		end

		response.reply(counter)

		response.reply("当前天气情况：")

		response.reply(date[counter])

		response.reply(weather[counter])

		response.reply(temper[counter])

		response.reply(wind[counter])

		response.reply(windp[counter])

      end

      Lita.register_handler(self)
    end
  end
end
