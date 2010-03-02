# NeedsVerify
module NeedsVerify

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def needs_verification opts={}

      #default_scope :conditions => {:verified => [0,1]}
  
      named_scope :unverified, :conditions => {:verified => 0}, :order => "created_at DESC"

      named_scope :accepted, :conditions => {:verified => 1}, :order => "created_at DESC"

      named_scope :rejected, :conditions => {:verified => 2}, :order => "created_at DESC"

      attr_protected :verified    

      include NeedsVerify::InstanceMethods

      extend NeedsVerify::SingletonMethods

    end

  end 

  module SingletonMethods
  end

  module InstanceMethods

    def verify
      self.verified = 1
      self.save
    end

    def unverify
      self.verified = 2
      self.save
    end
  
  end

end

ActiveRecord::Base.send(:include, NeedsVerify)
