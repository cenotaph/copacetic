ActiveAdmin.register Logo do

  index :as => :grid, :columns => 4 do |logo|
    div :for => logo do
      div link_to image_tag(logo.filename.url(:standard)), edit_admin_logo_path(logo)
      div "uploaded #{logo.created_at}"
    end
    
  end
    
end
