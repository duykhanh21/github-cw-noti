class PayloadController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    action = JSON.parse(request.raw_post)['action']
    p action
    case action
    when 'created', 'submitted', 'edited'
      return if params[:comment].nil?
      body = Chatwork.new_comment(params[:comment], params[:pull_request] || params[:issue])
    when 'opened'
      body = Chatwork.new_pull(params[:pull_request])
      return if params[:pull_request].nil?
    else
      render :json => {} and return
    end
    response = Chatwork.send_message body
    render :json => response
  end
end
