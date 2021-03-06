module Lita
  module Handlers
    class Calender < Handler
      # insert handler code here
      route(/^calender\s+(.+)/, :echo,command: true, help: { "calender 某年-某月" => "该月日历" })

      def echo(response)
      	# type = read_administer(3)
       #  if type[0] == "0"
	        time = response.matches[0][0]

			year=time.split("-")[0]
			month=time.split("-")[1]
			year=year.to_i
			month=month.to_i

			datum_year=2020
			datum_month=1
			datum_date=3


			def year_judge(x)
				if (x%4==0 && x%100!=0)|| x%400==0
					return 366
				else
					return 365
				end
			end

			def month_judge(x,y)
				case x
				when 1,3,5,7,8,10,12
					return 31
				when 4,6,9,11
					return 30
				when 2
					if year_judge(y)==365
						return 28
					else
						return 29
					end
				end
			end


			sum = 0
			if year<datum_year
				for i in year+1...datum_year
					sum += year_judge(i)
				end
				for j in month..12
					sum += month_judge(j,year)
				end
				sum = -sum
			elsif year>datum_year
				for i in datum_year...year
					sum += year_judge(i)
				end
				for j in 1..month
					sum += month_judge(j,year)
				end
			else 
				for j in 1...month
					sum += month_judge(j,year)
				end
			end

			change=sum%7
			final_day=(change+datum_date)
			if final_day>7
				final_day=final_day-7
			end
			final_day=final_day-1

			month_type=month_judge(month,year)
			
			response.reply("该月日历为：")
			response.reply("一  二  三  四  五  六  日")
			
			empty="-"

			ll=0
			em=["","","","","",""]
			em[ll]=empty*(final_day+final_day*3-3)
			for j in 0...month_type
				line_judge=j+final_day
				k=j+1

				if(line_judge%7==0)
					ll=ll+1
					em[ll]=em[ll]+k.to_s
				else
					
					if j>9
						em[ll]=em[ll]+"--"+k.to_s
					else
						em[ll]=em[ll]+"---"+k.to_s
					end
				end
			end
			response.reply(em[0])
			response.reply(em[1])
			response.reply(em[2])
			response.reply(em[3])
			response.reply(em[4])
			response.reply(em[5])
		# else
		# 	response.reply("该功能已经被关闭，请进入管理员模式打开该功能")
		# end
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
