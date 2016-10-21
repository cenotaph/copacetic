ThinkingSphinx::Index.define :cd, :with => :active_record do
  indexes title, :sortable => true
  indexes artist, sortable: true
  indexes description
  indexes label.name, as: :label, sortable: true

  has created_at, updated_at
end
