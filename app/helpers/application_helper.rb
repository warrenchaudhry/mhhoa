module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible in", role: 'alert') do
        concat content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' }, 'arial-label' => 'Close')
        concat message
      end)
    end
    nil
  end

  def yes_or_no(val)
    val ? 'Yes' : 'No'
  end

  def col_bg(status = nil)
    if status == 'inactive'
      'bg-warning'
    elsif status == 'paid'
      'bg-success'
    elsif status == 'partial'
      'bg-primary'
    end
  end

  def payments_coverage(payments)
    res = []
    grouped = payments.sort_by(&:billable_year).group_by(&:billable_year)
    grouped.each do |year, mdps|
      if mdps.size > 1
        min = mdps.collect(&:billable_month).min
        max = mdps.collect(&:billable_month).max
        res << '%s-%s %s' % [get_month_literal(min), get_month_literal(max), year]
      else
        res << mdps.last.billable_date
      end
    end
    res.join('<br>').html_safe
  end

  def get_month_literal(num)
    Date::MONTHNAMES[num]
  end
end
