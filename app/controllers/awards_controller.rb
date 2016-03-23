class AwardsController < ApplicationController
  before_action :check_user_score, only: :judge
  before_action :authenticate_user!
  def index
    @awards = Award.where("expire_at > ?",Time.now).order('odds ASC')
    @recent_awards = AwardItem.order("created_at DESC").limit(5)
  end

  def show_all
    @awards = current_user.award_items.where('expire_at > ?',Time.now).order('created_at DESC')
  end

  def judge
    @award = Award.judge(current_user) #判断用户中了什么奖
    current_user.update_attributes(score: current_user.score - 100) #更新用户积分
    respond_to do |format|
      format.js
      format.html{redirect_to awards_path}
    end
  end

  private
  def check_user_score
    if current_user.score < 100
      flash[:notice] = "抱歉，你的积分不足100，不能参与抽奖"
      redirect_to awards_path
    end
  end
end
