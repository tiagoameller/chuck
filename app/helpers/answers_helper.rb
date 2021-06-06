module AnswersHelper
  def render_answer(model)
    [].tap do |row|
      present(model) do |answer|
        row <<
          tag.div(nil, class: '.card') do
            concat(tag.div(nil, class: 'card-body p-1 d-flex align-items-center') do
              concat(tag.div(nil, class: 'bg-light p-3 mfe-3') do
                tag.img(nil, src: answer.icon_url, alt: 'chuck avatar')
              end)
              concat(tag.ul(nil, class: 'list-unstyled') do
                concat(tag.li(answer.value, class: 'text-value text-primary'))
                concat(
                  tag.li(
                    link_to(t('answer.source'), answer.url, target: '_blank', rel: 'noopener noreferrer'),
                    class: 'text-muted small'
                  )
                )
                if answer.categories_array.any?
                  concat(tag.li(nil) do
                    answer.categories_array.each do |category|
                      concat(tag.span(category, class: 'badge badge-info .mr-1'))
                    end
                  end)
                end
              end)
            end)
          end
        row << {
          row_id: dom_id(answer)
        }
      end
    end
  end
end

__END__

          .card
            .card-body.p-1.d-flex.align-items-center
              .bg-light.p-3.mfe-3
                img[src="#{answer.icon_url}" alt='chuck avatar']
              ul.list-unstyled
                li.text-value.text-primary
                  = answer.value
                li.text-muted.small
                  = link_to t('answer.source'), answer.url, target: '_blank', rel: 'noopener noreferrer'
                - if answer.categories_array.any?
                  li
                    - answer.categories_array.each_with_index do |category, idx|
                      span.badge.badge-info.mr-1
                        = category
                      - break if idx == 5

