# -*- encoding : utf-8 -*-
module ApplicationHelper

  def format_time(time) #格式化时间
    time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def hidden_email(email)  #example: 123456@qq.com => 123***@qq.com
    email = email.split('@')
    hidden_len = email.first.length / 2

    hidden_len.times do |n|
      email.first[-(n+1)] = "*"
    end
    email = email.first + '@' + email.last
  end
end
