class DelayedJob < ActiveRecord::Base
  self.attr_protected if self.to_s == 'Delayed::Backend::ActiveRecord::Job'   #loads protected attributes for                                                                                        # ActiveRecord instance
end