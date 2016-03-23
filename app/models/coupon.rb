class Coupon < ActiveRecord::Base
  belongs_to :user

  validates :verify_code,presence: true,uniqueness: {case_sensitive: false}
  validates :value,presence: true
  validates :expire_at,presence: true


  Permit_str = ('a'..'z').to_a   #允许使用的验证码字符
  (0..9).each { |n| Permit_str << n.to_s }  # a-z 0-9


  def self.generate(value,user_id=nil)  #生成优惠卷
    rand_str = ""
    6.times { rand_str << Permit_str[rand(Permit_str.length)]}
    cp_code = Time.now.sec.to_s + rand_str #当前秒数 + 6位随机码
    if !user_id.nil?
      coupon = Coupon.create(verify_code: cp_code,value: value,expire_at: (Time.now + 1.month),user_id: user_id)
    else
      coupon = Coupon.create(verify_code: cp_code,value: value,expire_at: (Time.now + 1.month))
    end
    return coupon
  end


end
