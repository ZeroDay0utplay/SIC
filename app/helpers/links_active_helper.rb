module LinksActiveHelper
  def is_active?(controller_name)
    (controller.controller_name == controller_name || controller.class.module_parent_name == controller_name) ? "active" : ""
  end

  def field_services?(controller_name)
    controller.controller_name == controller_name || controller.class.module_parent_name == controller_name
  end

  def check_namespace?(controller_name)
    controller.controller_name == controller_name || controller.class.module_parent_name == controller_name
  end
end
