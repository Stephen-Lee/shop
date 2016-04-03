class Admin::OrdersController < Admin::BaseController
  after_action :set_status_job, only: :deliver

  def index
    @paid_orders = Order.where(status: "paid").includes(:products)
    @sent_orders = Order.where(status: "sent").includes(:products)
    @history_orders = Order.where(status: "confirm").includes(:products)

    @statistic_orders = Order.where("status = ? OR status = ?","paid","confirm").includes(:products)
    today_orders = @statistic_orders.where("created_at > ?", Time.now.midnight)
    @today_sales = sales_amount(today_orders)

    week_orders = @statistic_orders.where("created_at > ?", (Time.now.wday).days.ago.midnight)
    @week_sales = sales_amount(week_orders)

    month_orders = @statistic_orders.where("created_at > ?", (Time.now.mday - 1).days.ago.midnight)
    @month_sales = sales_amount(month_orders)

    year_orders = @statistic_orders.where("created_at > ?", (Time.now.yday - 1).days.ago.midnight)
    @year_sales = sales_amount(year_orders)
  end

  def show_products
    @order = Order.find(params[:id])
    render "orders/show_products"  
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update_attributes(order_params)
    flash[:notice] = "修改完成"
    redirect_to admin_orders_path
  end

  def deliver
    @order = Order.find(params[:id])
    if @order.update_attributes(status: "sent")
      respond_to do |format|
       format.js
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.delete
    redirect_to admin_orders_path
  end

  private
  def order_params
    params.require(:order).permit(:buyer, :phone,:address)
  end

  def sales_amount(orders)
    total = 0
    orders.each do |order|
      total += order.total
    end
    return total
  end

  def set_status_job
    @order.handle_job
  end

end
