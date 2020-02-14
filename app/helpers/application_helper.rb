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
      {:text => 'スケジュール',       :path => schdule_show_path},
      {:text => '(イベントリスト)',   :path => events_path},
      {:text => 'ToDoリスト',         :path => '#'},
      {:text => 'PDCA入力',           :path => '#'},
      {:text => '目標設定',           :path => '#'},
      {:text => 'プロフィール変更',   :path => edit_user_registration_path}
    ]

    html = ''
    items.each do |item|
      text = item[:text]
      path = item[:path]
      html = html + %Q(<li#{sidebar_activate(path)}><a href="#{path}">#{text}</a></li>)
    end

    raw(html)
  end
end
