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
      	end
      Lita.register_handler(self)
    end
  end
end
