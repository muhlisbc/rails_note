class AdminsController < ApplicationController

  before_action :authenticate_as_admin!

  # GET /admin
  def index

  end

  # Collection's stat
  # GET /admin/stat/user.json
  def stat
    respond_to do |format|
      format.html { page_404 }
      format.json {
        year, month = [params[:year], params[:month]].map { |param| non_zero_int(param) }
        date = DateTime.new(year, month).utc rescue nil
        status, message, data = begin
            ["ok", "", params[:collection].capitalize.constantize.stat(date)]
          rescue
            ["error", "Invalid parameters", {}]
          end
        render json: {status: status, message: message, data: data}
      }
    end
  end

end
