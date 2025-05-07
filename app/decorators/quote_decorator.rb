class QuoteDecorator < Draper::Decorator
  delegate_all

  def state
    bill_shape = "success-bill"
    if model.state == "pending"
      bill_shape = "fail-bill"
    elsif model.state == "sended"
      bill_shape = "sended-bill"
    end
    status = I18n.t("enums.quote_state.#{model.state}")
    "<span class='badge #{bill_shape}'>#{status}</span>".html_safe
  end

  def interloc
    "<span class='badge'>#{h.inline_svg_tag("icons/interloc.svg")} Voir</span>"
  end
end
