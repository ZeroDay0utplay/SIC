class EnablePostgreSqlExtensions < ActiveRecord::Migration[8.0]
  def change
    # Enable the uuid-ossp extension in the public schema
    enable_extension "uuid-ossp"

    # Enable the unaccent extension in the public schema
    enable_extension "unaccent"
  end
end
