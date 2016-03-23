namespace :db do
	desc "fill sample data"
	task populate: :environment do
      Role.create!(
        name: "admin"
        )

      admin = User.create!(
        nick_name: "admin",
        email: "admin@admin.com",
        password: "password",
        password_confirmation: "password"
        )

      admin.authorities.create!(
         role_id: 1
        )

      cate_list = ["小说","生活","文艺","科技","教育"]
      cate_list.each do |cate|
            Category.create(
               name: cate
              )
       end 

      100.times do |n|
       name = "pig#{n}"
       email = "sample#{n}@qq.com"
       password = "471235649"
       
       User.create!(
          nick_name: "pig#{n}",
          email: "pig#{n}@qq.com",
          password: password,
          password_confirmation: password,
          age: 30,
          sex: "male",
          s_province: "广东省",
          s_city: "清远市"
       	)

       User.create!(
          nick_name: "dog#{n}",
          email: "dog#{n}@qq.com",
          password: password,
          password_confirmation: password,
          age: 23,
          sex: "female",
          s_province: "上海市",
          s_city: "上海市"
        )

       User.create!(
          nick_name: "cat#{n}",
          email: "cat#{n}@qq.com",
          password: password,
          password_confirmation: password,
          age: 18,
          sex: "female",
          s_province: "北京市",
        )

      end
	end
end