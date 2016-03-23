class Admin::AwardsController < Admin::BaseController
  def index
    @awards = Award.all
    @award = Award.new
  end

  def edit
    @award = Award.find(params[:id])
  end

  def create
    @award = Award.new(award_params)
    @award.save
    redirect_to admin_awards_path
  end

  def update
    @award = Award.find(params[:id])
    if @award.update_attributes(award_params)
      redirect_to admin_awards_path
    end
  end

  def destroy
    @award = Award.find(params[:id])
    if @award.delete
      redirect_to admin_awards_path
    end
  end

  private
  def award_params
    params.require(:award).permit(:name,:quantity,:expire_at,:odds)
  end
end
