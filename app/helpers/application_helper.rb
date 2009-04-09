# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_display
    if flash.key?(:success)
      out = flash[:success]
      status = :success
    elsif flash.key?(:notice)
      out = flash[:notice]
      status = :notice
    elsif flash.key?(:error)
      out = flash[:error]
      status = :error
    end
    #logger.debug("status: #{status.inspect} #{flash.inspect}")
    return '' if out.blank?
    render :partial => 'widgets/flash_display', :locals => {:message => out, :status => status}
  end
end
