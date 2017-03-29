require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = {email: "email@email.com", password: "password"}
    @user2 = {email: "email2@gmail.com", password: "password"}
    @note = {
      title:  "This is a title",
      content: "This is a content",
      tag_list: "tag1, tag2, tag3"
    }
    @get_actions = [:index, :new]
  end

  test "should fail to visit notes page if not authenticated" do
    @get_actions.each do |act|
      get url_for(controller: "notes", action: act)
      assert_redirected_to login_account_path
    end
  end

  test "should fail to visit notes page if email not confirmed" do
    user = User.create @user1
    post login_account_url, params: @user1
    @get_actions.each do |act|
      get url_for(controller: "notes", action: act)
      assert_redirected_to confirm_email_account_path
    end
  end

  test "should success to visit notes page if authenticated and email confirmed" do
    user = User.create @user1.merge(is_email_confirmed: true)
    post login_account_url, params: @user1
    @get_actions.each do |act|
      get url_for(controller: "notes", action: act)
      assert_response :success
    end
  end

  test "should fail to create note" do
    assert_no_difference("Note.count") do
      post notes_url, params: {note: @note}
      assert_redirected_to login_account_path
    end
  end

  test "should success to create note and only correct user can access the note" do
    user = User.create @user1.merge(is_email_confirmed: true)
    post login_account_url, params: @user1
    get new_note_url
    assert_response :success

    assert_difference("Note.count") do
      post notes_url, params: {note: @note}
      note2 = @note
      @note = Note.last
      assert_equal @note.title, note2[:title]
      assert_equal @note.content, note2[:content]
      assert_equal @note.tags, note2[:tag_list].split(", ")
      assert_redirected_to note_path(@note.id)
    end
    get logout_account_url

    get note_url(@note.id)
    assert_redirected_to login_account_path

    user2 = User.create @user2.merge(is_email_confirmed: true)
    post login_account_url, params: @user2
    get note_url(@note.id)
    assert_response :forbidden
  end

  test "should fail to update note" do
    user = User.create @user1.merge(is_email_confirmed: true)
    note = user.notes.create @note
    patch note_url(note.id), params: {note: @note}
    assert_redirected_to login_account_path
    user2 = User.create @user2.merge(is_email_confirmed: true)
    post login_account_url, params: @user2
    patch note_url(note.id), params: {note: @note}
    assert_response :forbidden
  end

  test "should success to update note" do
    user = User.create @user1.merge(is_email_confirmed: true)
    note = user.notes.create @note
    post login_account_url, params: @user1
    patch note_url(note.id), params: {note: @note.merge(title: "New title")}
    assert_redirected_to note_url(note.id)
    assert_equal Note.last.title, "New title"
  end

  test "should fail to delete note" do
    user = User.create @user1.merge(is_email_confirmed: true)
    note = user.notes.create @note
    delete note_url(note.id)
    assert_redirected_to login_account_path
    user2 = User.create @user2.merge(is_email_confirmed: true)
    post login_account_url, params: @user2
    delete note_url(note.id)
    assert_response :forbidden
  end

  test "should success to delete note" do
    user = User.create @user1.merge(is_email_confirmed: true)
    note = user.notes.create @note
    assert_not_nil Note.where(id: note.id).first
    post login_account_url, params: @user1
    delete note_url(note.id)
    assert_redirected_to notes_url
    assert_nil Note.where(id: note.id).first
  end

  test "should fail to visit shared note if private" do
    user = User.create @user1
    note = user.notes.create @note
    get share_note_url(note.id)
    assert_response :forbidden
  end

  test "should success to visit shared note if public" do
    user = User.create @user1
    note = user.notes.create @note.merge(is_public: true)
    get share_note_url(note.id)
    assert_response :success
  end

  teardown do
    User.delete_all
    Note.delete_all
  end

end
