require 'test_helper'

class ImageWorkerTest < ActiveSupport::TestCase
  test 'should do background processing and create 3 image variants' do
    book = build(:book, id: 1)
    book.save

    assert_empty book.image_derivatives

    ImageWorker.new.perform(book.id)
    book.reload

    assert_equal 1, Book.count
    assert_equal 2, book.image_derivatives.count

    assert book.image_derivatives.present?
    assert book.image
    assert book.image_derivatives.key?(:index)
    assert book.image_derivatives.key?(:thumbnail)

    assert_equal [250, 250], book.image_derivatives[:thumbnail].dimensions

    index = MiniMagick::Image.open(book.image_derivatives[:index])
    width_index, height_index = index.dimensions
    assert_equal [1024, 1024], [width_index, height_index]
  end
end
