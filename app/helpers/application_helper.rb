module ApplicationHelper

  # controller helper

  def page_403
    render plain: "Forbidden", status: 403
  end

  def page_404
    render plain: "Not found", status: 404
  end

  def non_zero_int(str)
    str.to_i < 1 ? nil : str.to_i
  end

  # view helper

  # create an automatic title from controller and action name
  def autotitle
    [:controller, :action].map { |e| params[e].to_s.singularize.titleize }.join(" · ").html_safe
  end

  def account_left_sb_menus
    menu = [{ctrl: "notes", text: "Notes", icon: "note", children: {"Index" => notes_path, "New" => new_note_path}}]
    menu += admin_left_sb_menus if current_user.is_admin
    menu
  end

  def admin_left_sb_menus
    [
      {ctrl: "users", text: "Users", icon: "people", children: {"Index" => users_path, "New" => new_user_path}},
      {ctrl: "admins", text: "Admin", icon: "verified_user", link: admin_path}
    ]
  end

  def left_sb_menu_link_attrs(link)
    link ? {href: link} : {class: "menu-toggle", href: "javascript:void(0);"}
  end

  def admin_info_boxes
    [
      {text: "NEW USERS", icon: "people", bg: "pink", number: User.new_this_month},
      {text: "NEW NOTES", icon: "note", bg: "green", number: Note.new_this_month}
    ]
  end

end
