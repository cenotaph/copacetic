ThinkingSphinx::Index.define :comic, :with => :active_record do
  indexes title, :sortable => true
  indexes description
  indexes publisher.name, as: :publisher, sortable: true

  has created_at, updated_at
end
