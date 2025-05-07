module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def profile_image(user, size: [50, 50])
    if user.photo.attached?
      user.photo.variant(resize_to_fill: size).processed
    else
      ActionController::Base.helpers.asset_path("default_avatar.png")
    end
  end

  def type_class(type)
    case type.to_sym
    when :notice then "success"
    when :alert then "danger"
    else "info"
    end
  end
end
