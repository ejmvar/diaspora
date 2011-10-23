class FixPhotoShareVisibilities < ActiveRecord::Migration
  class Photo < ActiveRecord::Base; end

  def self.up
    raise 'migration currently only compatable with mysql' if postgres?

    if Photo.first.respond_to?(:tmp_old_id)
      ['aspect_visibilities', 'share_visibilities'].each do
        ActiveRecord::Base.connection.execute <<SQL
        UPDATE #{vis_table}
          SET shareable_type='Post'
SQL
        ActiveRecord::Base.connection.execute <<SQL
        UPDATE #{vis_table}, photos
          SET #{vis_table}.shareable_type='Photo', #{vis_table}.shareable_id=photo.id
            WHERE #{vis_table}.shareable_id=photos.tmp_old_id
SQL
      end
    end
  end

  def self.down
  end
end