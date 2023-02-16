class ProductsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "products"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def receive(data)
  #   puts "Data received"
  # end
end
