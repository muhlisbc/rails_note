class NotesController < ApplicationController

  before_action :authenticate!
  before_action :set_note,                      only:   [:show, :edit, :update, :destroy]
  before_action :note_belongs_to_correct_user?, only:   [:show, :edit, :update, :destroy]

  # GET /notes
  def index
    @notes = current_user.notes.order(created_at: :desc).page(params[:page])
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:success] = t "notes.created"
      redirect_to @note
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      flash[:success] = t "notes.updated"
      redirect_to @note
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    flash[:success] = t "notes.deleted"
    redirect_to notes_url
  end

  def tag
    @notes = current_user.notes.where(tags: params[:tag]).page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :content, :tag_list, :is_public)
    end

    def note_belongs_to_correct_user?
      page_403 if @note.user_id.to_s != current_user.id.to_s
    end
end
