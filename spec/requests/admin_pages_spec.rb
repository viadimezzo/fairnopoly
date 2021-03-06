require 'spec_helper'

include Warden::Test::Helpers

describe 'ActiveAdminPages' do

  describe 'for non-admin users' do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

  end

  describe 'for admin users' do
    before :each do
      @admin = FactoryGirl.create(:admin_user)
      login_as @admin
      visit root_path
    end

    it 'shows the Admin link' do
      page.should have_content('Admin')
    end

    before :each do
      click_on 'Admin'
    end

    it 'gets redirected to ActiveAdmin Dashboard' do
      page.should have_content('Dashboard')
    end

    it 'should delete an Auction' do
      @auction = FactoryGirl.create(:auction)
      click_on 'Auctions'
      expect {
        click_on 'Delete'
      }.to change(Auction, :count).by(-1)
    end

    it 'should delete a category' do
      @category = FactoryGirl.create(:category)
      click_on 'Categories'
      expect {
        click_on 'Delete'
      }.to change(Category, :count).by(-1)
    end

    it 'should create a category' do
      click_on 'Categories'
      click_on 'New Category'
      expect {
        fill_in 'Name', with: 'Name'
        click_on 'Create Category'
      }.to change(Category, :count).by(1)
    end

    it 'should show the ffp page' do
      @ffp = FactoryGirl.create(:ffp)
      click_on 'Fair Founding Points'
      expect {
        click_on 'Delete'
      }.to change(Ffp, :count).by(-1)
    end

    it 'should show the ffp page with confirmed ffps' do
      @ffp = FactoryGirl.create(:ffp, :activated => true)
      click_on 'Fair Founding Points'
      page.should have_content('Confirmed')
    end

    it 'should confirm a ffp' do
      @ffp = FactoryGirl.create(:ffp, :activated => false)
      click_on 'Fair Founding Points'
      expect {
        click_on 'Confirm'
      }.to change(Ffp, :count).by(0)
      page.should have_content('Payment confirmed.')
    end

    it 'should show the faq page' do
      @faq = FactoryGirl.create(:faq)
      click_on 'Faqs'
      page.should have_content('View')
    end

    it 'should show the users page' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      page.should have_content('View')
    end

    it 'should make the user a founder' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Join as Founder'
      page.should have_content('Yes (Remove from Trustcommunity)')
    end

    it 'should make the user a founder' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Join as Founder'
      click_on 'Remove from Trustcommunity'
      page.should have_content('Join as Founder')
    end

    it 'should make the user an admin' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Join as admin'
      page.should have_content('Remove as admin')
    end

    it 'should remove the user as admin' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Join as admin'
      click_on 'Remove as admin'
      page.should have_content('Join as admin')
    end

    it 'should deactivate the user' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Deactivate User'
      page.should have_content('Activate User')
    end

    it 'should activate the user' do
      @user = FactoryGirl.create(:user)
      click_on 'Users'
      click_on 'Deactivate User'
      click_on 'Activate User'
      page.should have_content('Deactivate User')
    end

    it 'should show the users page' do
      @user = FactoryGirl.create(:user)
      @user = FactoryGirl.create(:user, :banned => true)
      @admin = FactoryGirl.create(:admin_user)
      click_on 'Users'
      expect {
        click_on 'Delete'
      }.to change(User, :count).by(-1)
    end
  end
end