class ImageWorker
  include Sidekiq::Worker

  def perform(record_id)
    record = Book.find(record_id)
    record.image_derivatives!
    record.save
  end
end
