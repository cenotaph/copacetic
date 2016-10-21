ThinkingSphinx::Index.define :creator, :with => :active_record do
  indexes firstname
  indexes lastname
  indexes description
  indexes items_creators.item.title
  polymorphs items_creators.item, to: %w{Comic Book}
  
end

