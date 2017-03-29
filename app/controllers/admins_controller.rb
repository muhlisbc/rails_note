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
        status, message, data, expire = begin
            ["ok", "", params[:collection].capitalize.constantize.stat(date), 3600]
          rescue
            ["error", "Invalid parameters", {}, 300]
          end
        expires_in expire, :public => true
        render json: {status: status, message: message, data: data}
      }
    end
  end

end
