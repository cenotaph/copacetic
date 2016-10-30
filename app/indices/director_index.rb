ThinkingSphinx::Index.define :director, :with => :active_record do
  indexes firstname
  indexes lastname, sortable: true
  # indexes description

  
end

