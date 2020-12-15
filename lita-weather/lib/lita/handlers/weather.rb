#coding=utf-8
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
          help: { 'weather + city(default为北京)' => "当前该时刻的天气状况"}
          ) 
      def weather(response)
      	type = read_administer(9)
        if type[0] == "0"
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
			regex1 = /skyid([^k]*\n)*/

			#0 日期 1 2天气情况 3温度 4风向 5 风力
			counter=0

			puts data

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

			response.reply(hour.to_s)

			while a.to_i<hour
				counter=counter+1
				a=date[counter][10,2]
				# response.reply(hour)
				# response.reply(counter)
			end

			response.reply("当前天气情况：")

			response.reply(date[counter])

			response.reply(weather[counter])

			response.reply(temper[counter])

			response.reply(wind[counter])

			response.reply(windp[counter])

			regex_date = /<h1>[^<h>\s]*/
			regex_weather = /p title="[^"]*/
			regex_low_tem = /<i>[^i]*/
			regex_high_tem = /<span>[^<]*/
			regex_wind = /span title="[^"]*/

			counter = 0
			counter1 = 0

			data_begin_1 = search_result.index('sky skyid')
			data_end_1 = search_result.index('<i class="line1"></i>')

			data_1 = search_result[data_begin_1,data_end_1-data_begin_1]
			date_list = 'date   :'
			weather_list = 'weather:'
			low_tem_list = 'low_tem:'
			high_tem_list = ''
			windp_list = 'wind_p:'
			wind_list1 = ''
			wind_list2 = ''
			data_1.scan(regex_date).each{|m|
				puts m[4,m.length-4]
				date_list = date_list + m[4,m.length-4]
			}
			data_1.scan(regex_weather).each{|m|
				puts m[9,m.length-9]
				# ad = (8-m.size.to_i)*empty
				ac = 11-(m[9,m.length-9].length.to_i)/2
				ad = "*"*ac
				weather_list = weather_list + m[9,m.length-9]+ad
			}
			data_1.scan(regex_low_tem).each{|m|
				puts m[3,m.length-5]
				ac = 10-(m[3,m.length-5].length.to_i)/2
				ad = "*"*ac
				if(counter==0)
					counter=1
					low_tem_list = low_tem_list + m[3,m.length-5]+ad
				else
					windp_list = windp_list + m[3,m.length-5]+ad
					counter=0
				end
			}
			data_1.scan(regex_high_tem).each{|m|
				puts m[6,m.length-6]
				ac = 11-(m[6,m.length-6].length.to_i)/2
				ad = "*"*ac
				high_tem_list = high_tem_list + m[6,m.length-6]+ad

			}
			data_1.scan(regex_wind).each{|m|
				puts m[12,m.length-12]
				if(counter1==0)
					ac = 11-(m[12,m.length-12].length.to_i)/2
					ad = "*"*ac
					counter1=1
					wind_list1 = wind_list1 + m[12,m.length-12]+ad
				else
					ac = 11-(m[12,m.length-12].length.to_i)/2
					ad = "*"*ac
					wind_list2 = wind_list2 + m[12,m.length-12]+ad
					counter1=0
				end
			}
			response.reply(date_list)
			response.reply(weather_list)
			response.reply(low_tem_list)
			
			ac = low_tem_list.length-high_tem_list.length
			ad = "*"*(ac/1.8)
			high_tem_list = "high_tem:"+ad + high_tem_list
			response.reply(high_tem_list)
			response.reply(windp_list)
			if(wind_list1.length>wind_list2.length)
				ac = wind_list1.length-wind_list2.length
				ad = "*"*ac
				wind_list2 = ad + wind_list2
				response.reply("PM_wind:"+wind_list2)
				response.reply("AM_wind:"+wind_list1)
			else
				response.reply("PM_wind:"+wind_list1)
				response.reply("AM_wind:"+wind_list2)
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
