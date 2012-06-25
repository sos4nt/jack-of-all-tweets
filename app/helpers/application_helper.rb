# encoding: UTF-8
module ApplicationHelper

  # @note This is an implementation specific hack that could break if Twitter
  #   changes the URL syntax
  # Returns an image URL for the given size. The following sizes are currently
  # supported:
  # * +:bigger+ - 73px by 73px
  # * +:normal+ - 48px by 48px
  # * +:mini+ - 24px by 24px
  # @param [String] image_url the default image URL
  # @param [Symbol] size the image size to return
  # @return [String] image URL for the given size
  def image_url_with_size(image_url, size = :normal)
    image_url.sub "_normal.", "_#{size}."
  end

  # Renders a simple Google like pagination with at most 10 entries
  # @example
  #    # within index.html.haml
  #    - pagination
  # @return [nil]
  def pagination
    return unless total_pages && total_pages > 1
    from = [1, total_pages - 5].max
    to   = [from + 9, total_pages].min
    haml_tag 'div.pagination' do
      haml_tag 'ul' do
        haml_tag :li, link_to("«", params.merge(page: previous_page), class: previous_page ? nil : 'disabled')
        (from..to).each do |page|
          haml_tag :li, link_to(page, params.merge(page: page)), class: page == current_page ? 'active' : nil
        end
        haml_tag :li, link_to("»", params.merge(page: next_page), class: next_page ? nil : 'disabled')
      end
    end
  end
end
