ActiveRecord::Base.send(:attr_accessible, nil)
ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)