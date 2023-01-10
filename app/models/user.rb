# frozen_string_literal: true

class User < ApplicationRecord
  default_scope { where(deleted: false) }
end
