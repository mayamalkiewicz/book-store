require 'image_processing/mini_magick'

class ImageUploader < Shrine
  def generate_location(io, record: nil, derivative: nil, **)
    if record
      table  = record.class.table_name
      id     = record.id
      prefix = derivative || 'original'
      "uploads/#{table}/#{id}/#{prefix}-#{super}"
    else
      super
    end
  end

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/webp]
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      thumbnail: magick.resize_to_fill!(250, 250),
      index: magick.resize_to_fill!(1024, 1024)
    }
  end

  add_metadata :dimensions do |io|
    FastImage.size(io)
  end
end
