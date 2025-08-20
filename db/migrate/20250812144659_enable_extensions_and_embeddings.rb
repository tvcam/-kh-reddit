class EnableExtensionsAndEmbeddings < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    enable_extension "plpgsql" unless extension_enabled?("plpgsql")
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    vector_available = ActiveRecord::Base.connection.select_value("SELECT 1 FROM pg_available_extensions WHERE name = 'vector' LIMIT 1").present?
    if vector_available
      enable_extension "vector" unless extension_enabled?("vector")
    end

    change_table :posts do |t|
      t.tsvector :tsv
    end
    change_table :comments do |t|
      t.tsvector :tsv
    end
    add_index :posts, :tsv, using: :gin, if_not_exists: true
    add_index :comments, :tsv, using: :gin, if_not_exists: true

    if vector_available
      change_table :posts do |t|
        t.vector :embedding, limit: 1536
      end
      change_table :comments do |t|
        t.vector :embedding, limit: 1536
      end
      add_index :posts, :embedding, using: :ivfflat, opclass: :vector_l2_ops, algorithm: :concurrently, if_not_exists: true
      add_index :comments, :embedding, using: :ivfflat, opclass: :vector_l2_ops, algorithm: :concurrently, if_not_exists: true
    end

    execute <<~SQL
      CREATE FUNCTION khreddit_posts_tsv_update() RETURNS trigger AS $$
      begin
        new.tsv := to_tsvector('simple', coalesce(new.title,'') || ' ' || coalesce(new.body,''));
        return new;
      end
      $$ LANGUAGE plpgsql;

      DROP TRIGGER IF EXISTS posts_tsv_update ON posts;
      CREATE TRIGGER posts_tsv_update BEFORE INSERT OR UPDATE ON posts
      FOR EACH ROW EXECUTE FUNCTION khreddit_posts_tsv_update();

      CREATE FUNCTION khreddit_comments_tsv_update() RETURNS trigger AS $$
      begin
        new.tsv := to_tsvector('simple', coalesce(new.body,''));
        return new;
      end
      $$ LANGUAGE plpgsql;

      DROP TRIGGER IF EXISTS comments_tsv_update ON comments;
      CREATE TRIGGER comments_tsv_update BEFORE INSERT OR UPDATE ON comments
      FOR EACH ROW EXECUTE FUNCTION khreddit_comments_tsv_update();
    SQL
  end
end


