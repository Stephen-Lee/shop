class OrderHandlerJob < ActiveJob::Base
  queue_as :default

  def perform(order)
  	if order.status == "not_paid"
  	  order.update_attributes(status: "closed")
  	elsif order.status == "sent"
  	   order.update_attributes(status: "confirm")
  	end
  end
end
