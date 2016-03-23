class Award < ActiveRecord::Base
  Base = 10000  #概率基数单位

  def self.judge(user) #判断中奖
    awards = Award.where("expire_at > ?",Time.now)
    total_odds = 0
    awards.each {|a| total_odds += a.odds} #总中奖基数
    rand_num = rand(Base)  #用于判断是否中奖

    if rand_num < total_odds  #中奖了（不是优惠卷）
      flag = 0
      rand_num = rand(total_odds) #用于判断中了什么奖

      awards.each do |a|
        award_range = (flag...(flag+a.odds)) #若随机数在几率区间则中奖
        if award_range.include?(rand_num) #中了奖品a？
          user.award_items.create(name: a.name,expire_at: a.expire_at)
          a.update_attributes(quantity: a.quantity - 1)    #a奖品剩余数-1
          return a.name
        else
          flag = flag + a.odds
        end
      end
    else
      random_coupon(user)  #随机面值优惠卷
    end
  end


  private
  def self.random_coupon(user)
    rand_num = rand(100)
    if rand_num < 25
      value = rand(5) + 6 # 25%几率 (6..10)元
    else
      value = rand(5) + 1   #(1..5)元
    end
    coupon = Coupon.generate(value,user.id) #生成1张优惠卷
    user.award_items.create(name: "#{value}元优惠卷",expire_at: coupon.expire_at)
    return "#{value}元优惠卷"
  end
end
