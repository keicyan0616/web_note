module ApplicationHelper
  
  def full_title(page_name = "")
    base_title = "Smart Web Notebook"
    
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  # 選択中のサイドメニューのクラスを返す
  def sidebar_activate(sidebar_link_url)
    current_url = request.headers['PATH_INFO']
    if current_url.match(sidebar_link_url)
      ' class="active side-item-custom"'
    else
      ' class="side-item-custom"'
    end
  end

  # サイドメニューの項目を出力する
  def sidebar_list_items
    items = [
      {:text => 'スケジュール',       :path => schdule_show_path,     :icon => 'icon_calender01.jpg' },
      {:text => '(イベントリスト)',   :path => events_path,           :icon => ''},
      {:text => 'ToDoリスト',         :path => todolist_show_path,    :icon => ''},
      {:text => '目標設定',           :path => goalset_show_path(code: 1),     :icon => ''},
      {:text => 'メモ帳',             :path => memopad_show_path,     :icon => ''},
      {:text => 'PDCA入力',           :path => '#',                   :icon => ''},
      {:text => 'プロフィール変更',   :path => edit_user_registration_path, :icon => 'icon_profile.jpg'}
    ]

    html = ''
    items.each do |item|
      text = item[:text]
      path = item[:path]
      icon = item[:icon]
      html = html + %Q(<li#{sidebar_activate(path)}><a href="#{path}">) + image_tag(icon, :size => '21x21', class: "mr-2") + %Q(#{text}</a></li>)
    end

    raw(html)
  end
end
