module ApplicationHelper
  def number_to_currency(price)
    sprintf("£%0.02f", price)
  end

  def render_if(conditon, record)
    if conditon
      render record
    end
  end
end
