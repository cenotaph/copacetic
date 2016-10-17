class Logo < ActiveRecord::Base

  mount_uploader :filename, LogoUploader
end
