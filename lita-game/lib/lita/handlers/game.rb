module Lita
  module Handlers
    class Game < Handler
      # insert handler code here
      route(
          /game_begin/,
          :game_begin,
          command: true,
          help: { 'game' => '玩一个简单的小游戏'}
          ) 
      def game_begin(response)
      	#主函数
      	write_administer(7,"1")
		puts "=========================================================="
		puts "井字棋"
		aFile = File.open("data.txt", "a+:UTF-8")
		File.delete("data.txt")
		aFile = File.open("data.txt", "a+:UTF-8")
		aFile.syswrite("begin\n")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		aFile.syswrite("0")
		response.reply("已经进入游戏进程")
		arr = IO.readlines("data.txt")
	    save = arr[1]
  		save_data = [[save[0].to_i,save[1].to_i,save[2].to_i],[save[3].to_i,save[4].to_i,save[5].to_i],[save[6].to_i,save[7].to_i,save[8].to_i]]
		if rand(0..100).to_i<50
		    response.reply("=================")
		    response.reply("我方先行")
		    response.reply("=================")
		    parr(save_data,response)
		else
		    response.reply("=================")
		    response.reply("CPU先行")
		    response.reply("=================")
		    
		    save_data=aip(save_data)
		    win=winp(save_data)
		    parr(save_data,response)
		    save_game(save_data)
		end
		address_add = ''
        address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

        regex = "/chatbot-[^.]*/"

        Dir.entries(File.join(address,"")).each {|e|

         if(e.index('bot')==4)
          address_add = address_add + e.to_s
          puts address_add
        end
        }
        puts address_add
        address_new = address + address_add + "/lita-test/administer.txt"
        list = IO.readlines(address_new)

      end

      route(
      	/(.+)/,
          :game_init,
          command: true,
          help: { '一些其他设定' =>''}
      	)
      def game_init(response)
      	new_data = IO.readlines("data.txt")
      	if response.matches[0][0] != "game_begin"
      		if response.matches[0][0] == "quit" && new_data[0] == "begin\n"     			
      			File.delete("data.txt")
			    aFile = File.open("data.txt", "a+:UTF-8")
			    aFile.syswrite("stop\n")
			    aFile.syswrite(new_data[1])
			    # aFile.syswrite("\n")
			    aFile.syswrite(new_data[2])
			    write_administer(7,"0")
			    puts "游戏暂停，数据已保存"
			elsif response.matches[0][0] == "continue" && new_data[0] == "stop\n"
				File.delete("data.txt")
			    aFile = File.open("data.txt", "a+:UTF-8")
			    aFile.syswrite("begin\n")
			    aFile.syswrite(new_data[1])
			    # aFile.syswrite("\n")
			    aFile.syswrite(new_data[2])
			    write_administer(7,"1")
			    puts "游戏继续"
	      	elsif read_administer(7) == "1"
	      		response.reply("游戏正在运行中")
	      		puts new_data
	      		puts response.matches[0][0]
	      	end
	    end
      end
      route(
      	/[1-9]/,
          :game_run,
          command: true,
          help: { '天地大同！！！！' =>''}
      	)
      def game_run(response)
      	new_data = IO.readlines("data.txt")
      	if (new_data[0] == "begin\n")
	      	win=0

	      	new_place = response.matches[0][0].to_i
	      	puts new_data[1][new_place-1]
	      	if new_data[1][new_place-1] == "0"
		      	new_data[1][new_place-1] = "1"
		      	save = new_data[1]
			    save_data = [[save[0].to_i,save[1].to_i,save[2].to_i],[save[3].to_i,save[4].to_i,save[5].to_i],[save[6].to_i,save[7].to_i,save[8].to_i]]
			    save_data = save_data
			      	
				win = winp(save_data)

				if win==0

					save_data = aip(save_data)
		      		win = winp(save_data)
		      	end
		      	parr(save_data, response)
		      	if win!= 0
			      	case win
					  when 1 then response.reply("游戏结束，我方胜利")
					  when 2 then response.reply("游戏结束，CPU胜利")
					  when 3 then response.reply("游戏结束，双方平局")
					end
					File.delete("data.txt")
					aFile = File.open("data.txt", "a+:UTF-8")
					write_administer(7,"0")
					response.reply("游戏已经结束，如果想再来一局请从新进入")
				else
		      	save_game(save_data)
		      	end
		    else
		    	response.reply("这个位置已经有子了，请换个位置")
		    end
		else
			puts "已退出"
		end


      end

      		def save_game(q)
      			game_data = ""
      			for i in 0..2
			    	for j in 0..2
			    		game_data = game_data + q[i][j].to_s
			    	end
			    end
			    File.delete("data.txt")
			    aFile = File.open("data.txt", "a+:UTF-8")
			    aFile.syswrite("begin\n")
			    aFile.syswrite(game_data)
			    aFile.syswrite("\n")
			    aFile.syswrite("runing")
      		end

					#打印棋盘
			def parr(q,response)
				print_arr = [[".",".","."],[".",".","."],[".",".","."]]
			  puts "当前的棋盘"
			  for i in 0..2
			    for j in 0..2

			      case q[i][j]
			      when 0 then print_arr[i][j] = ". "
			      when 1 then print_arr[i][j] = "O "
			      when 2 then print_arr[i][j] = "X "
			      end
			      
			    end
				

			  end
			  response.reply(print_arr[0][0]+print_arr[0][1]+print_arr[0][2])
			  response.reply(print_arr[1][0]+print_arr[1][1]+print_arr[1][2])
			  response.reply(print_arr[2][0]+print_arr[2][1]+print_arr[2][2])
			  response.reply("请输入你落子的位置")
			  response.reply("1 2 3\n4 5 6\n7 8 9\n")
			  response.reply("=================")
			  response.reply("位置：")
			end
			#输入落子
			def inputp(q)
			  err=0
			  while err==0
			    puts "请输入你落子的位置"
			    puts "1 2 3\n4 5 6\n7 8 9\n"
			    puts "================="
			    print "位置："
			    getnum=gets.to_i-1
			    puts "================="
			    i=(getnum/3).to_i
			    j=(getnum%3).to_i
			    if getnum>8||getnum<0
			      puts "非法数值,请重新输入"
			      parr q
			    elsif q[i][j]==0
			      q[i][j]=1
			      err=1
			    else
			      puts"这个位置已经有子了，请换个位置"
			      parr q
			    end
			  end
			  return q
			end
			#CPU2落子
			def aip(q)
			  err=0
			  kong=0
			  #CPU预判系统
			  #CPU先行，大概率落子中间
			  for i in 0..2
			    for j in 0..2
			      if q[i][j]==0
			        kong+=1
			      end
			    end
			  end
			  if kong==9
			    if rand(0..100).to_i<90
			      q[1][1]=2
			      err=1
			    end
			  end
			  #需要预判的情况1：该CPU还差一步就赢了
			  if err==0
			    for i in 0..2
			      for j in 0..2
			        if q[i][j]==0
			          q[i][j]=2
			          w=winp q
			          if w==2
			            err=1
			            break
			          else
			            q[i][j]=0
			          end
			        end
			      end
			      if err==1
			        break
			      end
			    end
			  end
			  #需要预判的情况2：该CPU的对手还差一步就赢了
			  if err==0
			    for i in 0..2
			      for j in 0..2
			        if q[i][j]==0
			          q[i][j]=1
			          w=winp q
			          if w==1
			            q[i][j]=2
			            err=1
			            break
			          else
			            q[i][j]=0
			          end
			        end
			      end
			      if err==1
			        break
			      end
			    end
			  end
			  #不存在预判结果，CPU随机行动
			  while err==0
			    getnum=rand(0..8).to_i
			    i=(getnum/3).to_i
			    j=(getnum%3).to_i
			    if q[i][j]==0
			      q[i][j]=2
			      err=1
			    else
			    end
			  end
			  return q
			end
			#CPU1落子
			def aipme (q)
			  err=0
			  kong=0
			  #CPU预判系统
			  #CPU先行，大概率落子中间
			  for i in 0..2
			    for j in 0..2
			      if q[i][j]==0
			        kong+=1
			      end
			    end
			  end
			  if kong==9
			    if rand(0..100).to_i<90
			      q[1][1]=1
			      err=1
			    end
			  end
			  #需要预判的情况1：该CPu还差一步就赢了
			  if err==0
			    for i in 0..2
			      for j in 0..2
			        if q[i][j]==0
			          q[i][j]=1
			          w=winp q
			          if w==1
			            err=1
			            break
			          else
			            q[i][j]=0
			          end
			        end
			      end
			      if err==1
			        break
			      end
			    end
			  end
			  #需要预判的情况2：该CPU的对手还差一步就赢了
			  if err==0
			    for i in 0..2
			      for j in 0..2
			        if q[i][j]==0
			          q[i][j]=2
			          w=winp q
			          if w==2
			            q[i][j]=1
			            err=1
			            break
			          else
			            q[i][j]=0
			          end
			        end
			      end
			      if err==1
			        break
			      end
			    end
			  end
			  #不存在预判结果，CPU随机行动
			  while err==0
			    getnum=rand(0..8).to_i
			    i=(getnum/3).to_i
			    j=(getnum%3).to_i
			    if q[i][j]==0
			      q[i][j]=1
			      err=1
			    else
			    end
			  end
			  return q
			end
			#判断胜负
			def winp(q)
			  if q[0][0]==q[0][1]&&q[0][1]==q[0][2]&&q[0][0]!=0
			    out=q[0][0]
			  elsif q[1][0]==q[1][1]&&q[1][1]==q[1][2]&&q[1][0]!=0
			    out=q[1][0]
			  elsif q[2][0]==q[2][1]&&q[2][1]==q[2][2]&&q[2][0]!=0
			    out=q[2][0]
			  elsif q[0][0]==q[1][0]&&q[0][0]==q[2][0]&&q[0][0]!=0
			    out=q[0][0]
			  elsif q[0][1]==q[1][1]&&q[0][1]==q[2][1]&&q[0][1]!=0
			    out=q[0][1]
			  elsif q[0][2]==q[1][2]&&q[0][2]==q[2][2]&&q[0][2]!=0
			    out=q[0][2]
			  elsif q[0][0]==q[1][1]&&q[1][1]==q[2][2]&&q[0][0]!=0
			    out=q[0][0]
			  elsif q[2][0]==q[1][1]&&q[1][1]==q[0][2]&&q[2][0]!=0
			    out=q[2][0]
			  else
			    kong=0
			    for i in 0..2
			      for j in 0..2
			        if q[i][j]==0
			          kong+=1
			        end
			      end
			    end
			    if kong==0
			      out=3
			    else
			      out=0
			    end
			  end
			  return out
			end
			#进行游戏
			def play

			  win=0
			  if rand(0..100).to_i<50
			    puts "================="
			    puts "我方先行"
			    puts "================="
			    if win==0
			      arr=inputp(arr)
			      win=winp(arr)
			      if win==0
			        arr=aip(arr)
			        win=winp(arr)
			      end
			      parr arr
			    end
			  else
			    puts "================="
			    puts "CPU先行"
			    puts "================="
			    if win==0
			      arr=aip(arr)
			      win=winp(arr)
			      parr arr
			      if win==0
			        arr=inputp(arr)
			        win=winp(arr)
			        if win==1
			          parr arr
			        end
			      end
			    end
			  end
			  puts "================="
			  case win
			  when 1 then puts "游戏结束，我方胜利"
			  when 2 then puts "游戏结束，CPU胜利"
			  when 3 then puts "游戏结束，双方平局"
			  end
			  "================="
			end
			#CPU对战模式
			def playcpu
			  arr=[[0,0,0],[0,0,0],[0,0,0]]
			  win=0
			  parr arr
			  if rand(0..100).to_i<50
			    puts "================="
			    puts "CPU1先行"
			    puts "================="
			    while win==0
			      arr=aipme(arr)
			      win=winp(arr)
			      parr arr
			      if win==0
			        arr=aip(arr)
			        win=winp(arr)
			        parr arr
			      end

			    end
			  else
			    puts "================="
			    puts "CPU2先行"
			    puts "================="
			    while win==0
			      arr=aip(arr)
			      win=winp(arr)
			      parr arr
			      if win==0
			        arr=aipme(arr)
			        win=winp(arr)
			        if win==1
			          parr arr
			        end
			      end
			    end
			  end
			  puts "================="
			  case win
			  when 1 then
			    puts "游戏结束，CPU1胜利"
			    $cpu1win+=1
			  when 2 then puts "游戏结束，CPU2胜利"
			  $cpu2win+=1
			  when 3 then puts "游戏结束，双方平局"
			  end
			  "================="
			end
			#主函数
			def write_administer(q,run)
				address_add = ''
		        address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

		        regex = "/chatbot-[^.]*/"

		        Dir.entries(File.join(address,"")).each {|e|

		         if(e.index('bot')==4)
		          address_add = address_add + e.to_s
		          puts address_add
		        end
		        }
		        puts address_add
		        address_new = address + address_add + "/lita-test/"
		        Dir.entries(File.join(address_new,"")).each {|e|

		         puts e
		        
		        }
		        address_new = address + address_add + "/lita-test/administer.txt"
		        arr = IO.readlines(address_new)
		        puts arr
		        arr[q][0] = run
		        File.delete(address_new)
			    aFile = File.open(address_new, "a+:UTF-8")
			    for i in 0..9
			    	aFile.syswrite(arr[i])
			    end
			    arr = IO.readlines(address_new)
			    puts arr
			    puts ("write")

			end

			def read_administer(q)
				address_add = ''
		        address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

		        regex = "/chatbot-[^.]*/"

		        Dir.entries(File.join(address,"")).each {|e|

		         if(e.index('bot')==4)
		          address_add = address_add + e.to_s
		          puts address_add
		        end
		        }
		        puts address_add
		        puts ("read")

		        address_new = address + address_add + "/lita-test/administer.txt"
		        arr = IO.readlines(address_new)

		        return arr[q][0]
			end

		


      Lita.register_handler(self)
    end
  end
end
