require 'test_helper'
require 'action_controller'
require 'action_controller/test_process.rb'

class GuildPhotoTest < ActiveSupport::TestCase

  fixtures :all

  def setup
    @user = User.find(1)
    @guild = Guild.create({:game_id => 1, :name => 'guild name', :description => 'guild description', :president_id => @user.id})
    @album = @guild.album
    @guild.requests.create(:user_id => 2, :status => 2).accept_request
    assert User.find(2).participated_guilds_count == 1
  end

  # 测试计数器 
  test "相册的照片计数器" do
    @photo1 = save_photo 'public/images/default_guild.jpg'
    @album.reload
    assert_equal @album.photos_count, 1
    @photo2 = save_photo 'public/images/castle.jpg'
    @album.reload
    assert_equal @album.photos_count, 2
    @photo1.destroy
    @album.reload
    assert_equal @album.photos_count, 1
    @photo2.destroy
    @album.reload
    assert_equal @album.photos_count, 0
  end

  # 测试自动赋值
  test "相片会继承相册的一些属性" do
    @photo = save_photo 'public/images/default_guild.jpg'
    assert_equal @photo.privilege, 1
    assert_equal @photo.game_id, @album.game_id
  end

  # 封面
  test "设置新封面" do
    @cover = save_photo 'public/images/default_guild.jpg'
    @album.update_attributes(:cover_id => @cover.id)
    assert_equal @album.cover, @cover
  end

  test "删除当前封面" do
    @cover = save_photo 'public/images/default_guild.jpg'
    @album.update_attributes(:cover_id => @cover.id)
    @cover.reload and @cover.destroy
    @album.reload
    assert_nil @album.cover_id
  end   

  # 测试validate 
  test "没有相册" do
    path = 'public/images/default_guild.jpg'
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    @photo = GuildPhoto.create(:poster_id => @user.id, :uploaded_data => ActionController::TestUploadedFile.new(path, mimetype))
    assert_equal @photo.errors.on_base, '没有相册'
  end

  test "没有上传者" do
    path = 'public/images/default_guild.jpg'
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    @photo = GuildPhoto.create(:album_id => @album.id, :uploaded_data => ActionController::TestUploadedFile.new(path, mimetype))
    assert_equal @photo.errors.on_base, '没有上传者'
  end


protected
    
  def save_photo path
    mimetype = `file -ib #{path}`.gsub(/\n/,"")
    GuildPhoto.create(:album_id => @album.id, :poster_id => @user.id, :uploaded_data => ActionController::TestUploadedFile.new(path, mimetype))
  end

end
