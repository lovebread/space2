class Game < ActiveRecord::Base

  has_many :servers, :class_name => 'GameServer', :dependent => :destroy
  
  has_many :areas, :class_name => 'GameArea', :dependent => :destroy

  has_many :professions, :class_name => 'GameProfession', :dependent => :destroy

  has_many :races, :class_name => 'GameRace', :dependent => :destroy

	has_many :events, :order => 'confirmed_count DESC'

	has_many :guilds, :order => '(members_count + veterans_count + 1) DESC'

	has_many :albums, :class_name => 'PersonalAlbum', :order => "uploaded_at DESC", :conditions => ["photos_count != ?", 0]

	has_many :blogs, :order => 'digs_count DESC'

	has_many :characters, :class_name => 'GameCharacter'

	has_many :users, :through => :characters, :uniq => true

  has_many :attentions, :class_name => 'GameAttention'

  has_many :news

  named_scope :sexy, :order => "(characters_count - last_week_characters_count) DESC"

	named_scope :hot, :conditions => "attentions_count != 0", :order => "(attentions_count - last_week_attentions_count) DESC" 

	named_scope :beta, :conditions => ["sale_date > ?", Time.now.to_s(:db)], :order => 'sale_date DESC'

	acts_as_taggable :create_conditions => lambda {|tagging, game, user| tagging.nil? || tagging.created_at < 10.days.ago }
  
	acts_as_rateable :create_conditions => lambda {|rating, game, user| (rating.nil? || rating.created_at < 10.days.ago) and user.games.include?(game) }

  acts_as_shareable

	acts_as_commentable :order => 'created_at DESC', :delete_conditions => lambda {|user, game, comment| false }, :recipient_required => false

  acts_as_pinyin :name => "pinyin" 

  acts_as_feed_recipient

	def new_game?
		sale_date.nil? or sale_date > Date.today
	end

  def relative_new?
		sale_date.nil? or sale_date > Date.today<<(6)
	end  

end
