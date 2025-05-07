module BootstrapPaginationHelper
  class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def container_attributes
      {class: "pagination justify-content-center"}
    end

    def previous_or_next_page(page, text, classname)
      if page
        tag(:li, link(text, page, class: "page-link", data: {action: "search#paginate"}), class: "#{classname} page-item")
      else
        tag(:li, tag(:a, text, href: "#", class: "page-link", data: {action: "search#paginate"}), class: "#{classname} page-item disabled")
      end
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, "Précedent", "prev-next-link previous")
    end

    def next_page
      num = @collection.current_page < total_pages && @collection.current_page + 1
      previous_or_next_page(num, "Suivant", "prev-next-link next")
    end

    def page_input_with_total
      input_tag = tag(:input, "",
        type: "number",
        value: current_page,
        size: 2,
        max: total_pages,
        "data-action": "search#search",
        "data-search-target": "pageInput",
        class: "form-control input-page")

      page_info = "#{input_tag} <span class='separate'>/</span><span class='total-page'>#{total_pages}</span>"
      tag(:li, page_info.html_safe, class: "page-item")
    end

    def html_container(html)
      tag(:ul, html, container_attributes)
    end

    def to_html
      list_items = [previous_page, page_input_with_total, next_page].join(@options[:link_separator])
      html_container(list_items)
    end
  end
end
