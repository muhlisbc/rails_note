class PageController < ApplicationController

  def index
    
  end

  def share_note
    @note = Note.find(params[:id])
    if @note.is_public
      @title = @note.title
      render :share_note, layout: "page"
    else
      page_403
    end
  end

  def tos
    @title = "Term of Service"
    render :tos, layout: "page"
  end
end
