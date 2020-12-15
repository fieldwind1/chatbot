require 'launchy'
module Lita
  module Handlers
    class Test < Handler
    	flag=1
      # insert handler code here
      route(
          /administer login\s+(.+)/,
          :login,
          command: true,
          help: { 'test' => 'prints N+N'}
          ) 

      def login(response)
        # 读取用户名
        data = response.matches[0][0]
        # 录入已登录用户名
        administer = read_administer(0)
        print data
        # 如果二者相等
        if data == administer[1,administer.length-3]
          after(1) {  write_administer(0,"1")
          }
         
          response.reply("请继续输入密码")
        else
          response.reply("管理员用户名错误")
        end

      end

            route(
          /(.+)/,
          :password,
          command: true,
          help: { 'test' => 'prints N+N'}
          ) 

      def password(response)
        # 读取密码
        data = response.matches[0][0]
        # 录入已登录密码
        administer = read_administer(1)
        type = read_administer(0)
        puts administer[0,administer.length-2]
        # 如果二者相等同时之前用户名正确
        if type[0] == "1"
          if data == administer[0,administer.length-2] 
            write_administer(0,"2")
            response.reply("密码正确，激活管理员模式一分钟")
            after(60) { |timer| 
            response.reply("管理员模式已经关闭") 
            write_administer(0,"0")
          }
          else
            response.reply("输入密码错误")
          end
        end

      end

        route(
      /^check/,
      :check,
      command: true,
      help: { 'test' => 'prints N+N'}
      ) 

      def check(response)
        type = read_administer(0)
        if type[0] == "2"
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
            response.reply(arr) 
        else
          response.reply("该命令仅在管理员模式下才能使用，请登录并开启管理员模式")
        end

      end

        route(
      /open\s+([2-9])&/,
      :open,
      command: true,
      help: { 'test' => 'prints N+N'}
      ) 

      def open(response)

        type = read_administer(0)
        if type[0] == "2"
          data = response.matches[0][0]
          response.reply(data) 
          write_administer(data.to_i,"0")
        else
          response.reply("该命令仅在管理员模式下才能使用，请登录并开启管理员模式")
        end
      end

     route(
      /close\s+(\d)/,
      :close,
      command: true,
      help: { 'test' => 'prints N+N'}
      ) 

      def close(response)

        type = read_administer(0)
        if type[0] == "2"
          data = response.matches[0][0]
          response.reply(data) 
          write_administer(data.to_i,"9")
        else
          response.reply("该命令仅在管理员模式下才能使用，请登录并开启管理员模式")
        end
      
      end


      def write_administer(q,run)
        address_add = ''
            address = "/app/vendor/bundle/ruby/2.6.0/bundler/gems/"

            regex = "/chatbot-[^.]*/"

            Dir.entries(File.join(address,"")).each {|e|

             if(e.index('bot')==4)
              address_add = address_add + e.to_s

            end
            }

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

            end
            }

            puts ("read")

            address_new = address + address_add + "/lita-test/administer.txt"
            arr = IO.readlines(address_new)

            return arr[q]
      end

      Lita.register_handler(self)
    end
  end
end
