# require 'rubygems'
# require 'mechanize'
require 'http'
require 'rubygems'
require 'mechanize'
module Lita
  module Handlers
    class Answer < Handler
      # insert handler code here
      route(
          /answer\s+(.+)/,
          :answer,
          command: true,
          help: { 'answer+一些特定的词汇' => 'prints 关于这个词的简介'}
          ) 
      	def answer(response)
          type = read_administer(2)
          if type[0] == "0"
      		  # 读取数据
        		data=response.matches[0][0]
        		# 新建mechanize变量
        		agent = Mechanize.new
        		# 登录百度页面
      			page = agent.get('http://www.baidu.com/')
      			# 录入用户搜索的内容并加上百度百科
      			baidu_form = page.form('f')
      			baidu_form.wd = data
      			baidu_form.wd = baidu_form.wd+"百度百科"
      			page = agent.submit(baidu_form)
      			# 进程报告
      			response.reply("少女祈祷中。。。")
      			# 筛选跳转至百度百科的第一个链接
      			page = agent.click(page.link_with(:text => /- 百度百科/))
      			# 将该链接放入http中
      			newone = page.uri
      			document=HTTP.get(newone).body
      			search_result = document.readpartial
      			# 读取百度百科的前面介绍并打印出来
      			text_begin=search_result.index('name="description"')
      			text_end=search_result.rindex('。')
      			response.reply(search_result[text_begin+28,text_end-text_begin-28+1])
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
