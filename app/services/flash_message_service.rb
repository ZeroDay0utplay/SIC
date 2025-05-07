class FlashMessageService
  def initialize(controller_context)
    @controller = controller_context
  end

  def call(type, message)
    @controller.flash.now[type] = message
    @controller.render turbo_stream: @controller.view_context.turbo_stream.replace(
      "flash_messages",
      partial: "layouts/flash"
    )
  end

  def build_stream(type, message)
    @controller.flash.now[type] = message
    @controller.view_context.turbo_stream.replace(
      "flash_messages",
      partial: "layouts/flash"
    )
  end
end
