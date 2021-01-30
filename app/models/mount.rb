class Mount < ApplicationRecord
  belongs_to :volume
  belongs_to :container
end
