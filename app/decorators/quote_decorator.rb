class QuoteDecorator < Draper::Decorator
  delegate_all

  def state
    bill_shape = "success-bill"
    if model.state == "Pending"
      bill_shape = "pending-bill"
    elsif model.state == "Refused"
      bill_shape = "fail-bill"
    end
    "<span class='badge #{bill_shape}'>#{model.state}</span>".html_safe
  end

  def interloc
    "<span class='badge'>#{h.inline_svg_tag("icons/interloc.svg")} Voir</span>"
  end
end
