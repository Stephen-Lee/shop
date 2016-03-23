class Admin::HomeController < Admin::BaseController

  def dashboard
    @time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    area_chart_data
    sex_chart_data
    age_chart_data
  end

  def root_manage
    @banners = Banner.all
    @banner = Banner.new
  end

  private
  def area_chart_data
    #用户最多的10个城市
    @top_provinces = User.select("s_province, count(*)").where.not(s_province: nil).group("s_province").order("count(*) DESC").limit(10)

    @provinces_user_count = [] #10个城市的用户数
    @top_provinces.each do |province|
      @provinces_user_count << User.where(s_province: province.s_province).count
    end
  end

  def sex_chart_data
    @male_count = User.where(sex: "male").count
    @female_count = User.where(sex: "female").count
  end

  def age_chart_data
    @age_15_20 = User.where(age: 15..20).count
    @age_21_25 = User.where(age: 21..25).count
    @age_26_30 = User.where(age: 26..30).count
    @age_31_35 = User.where(age: 31..35).count
    @age_36_40 = User.where(age: 36..40).count
    @age_old = User.where("age > 40").count
    @average_age = User.average("age").to_i
  end
end
