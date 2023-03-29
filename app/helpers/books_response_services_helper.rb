module BooksResponseServicesHelper
  # Returns a JSON representation of a book with additional data
  def book_as_json(book)
    book_json = book.as_json

    # Add comments with user data to the JSON
    comments = book.comments.map do |comment|
      comment.as_json.merge({ user: comment.user })
    end

    users_books = book.users_books.as_json

    percentage_of_users_commented = calculate_percentage_of_users_commented(comments.count, users_books.count)

    # Merge additional data into the book JSON
    book_json.merge(
      comments:,
      users_books:,
      percentage_of_users_commented:,
      comments_count: comments.count
    )
  end

  private

  # Calculate the percentage of users who commented on the book
  def calculate_percentage_of_users_commented(comments_count, users_books_count)
    users_books_count == 0 ? 0 : (comments_count.to_f / users_books_count.to_f) * 100.0
  end
end
