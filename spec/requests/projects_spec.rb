require "rails_helper"

RSpec.describe ProjectsController, :vcr do
  before :each do
    PackageManager::Rubygems::URL
    @project = create(:project)
    version = create(:version, project: @project)
    create(:dependency, version: version)
    Project.__elasticsearch__.import force: true
    Project.__elasticsearch__.refresh_index!
  end

  describe "GET #index" do
    it "responds successfully", type: :request do
      visit root_path
      expect(page).to have_content 'Libraries.io'
    end
  end

  describe "GET #bus_factor" do
    it "responds successfully", type: :request do
      visit bus_factor_path
      expect(page).to have_content 'Bus Factor'
    end

    context "filtered by language" do
      it "responds successfully", type: :request do
        visit bus_factor_path(language: 'Ruby')
        expect(page).to have_content 'Bus Factor'
      end
    end
  end

  describe "GET #unlicensed" do
    it "responds successfully", type: :request do
      visit unlicensed_path
      expect(page).to have_content 'Unlicensed Libraries'
    end

    context "filtered by platform" do
      it "responds successfully" do
        visit unlicensed_path(platform: 'Rubygems')
        expect(page).to have_content 'Unlicensed Libraries'
      end
    end
  end

  describe "GET #deprecated" do
    it "responds successfully", type: :request do
      visit deprecated_path
      expect(page).to have_content 'Deprecated'
    end

    context "filtered by platform" do
      it "responds successfully" do
        visit deprecated_path(platform: 'Rubygems')
        expect(page).to have_content 'Deprecated'
      end
    end
  end

  describe "GET #removed" do
    it "responds successfully", type: :request do
      visit removed_path
      expect(page).to have_content 'Removed'
    end

    context "filtered by platform" do
      it "responds successfully" do
        visit removed_path(platform: 'Rubygems')
        expect(page).to have_content 'Removed'
      end
    end
  end

  describe "GET #unmaintained" do
    it "responds successfully", type: :request do
      visit unmaintained_path
      expect(page).to have_content 'Unmaintained'
    end

    context "filtered by platform" do
      it "responds successfully" do
        visit unmaintained_path(platform: 'Rubygems')
        expect(page).to have_content 'Unmaintained'
      end
    end
  end

  describe "GET #unseen_infrastructure" do
    it "responds successfully", type: :request do
      visit unseen_infrastructure_path
      expect(page).to have_content 'Unseen Open Source Infrastructure'
    end

    context "filtered by platform" do
      it "responds successfully" do
        visit unseen_infrastructure_path(platform: 'Rubygems')
        expect(page).to have_content 'Unseen Open Source Infrastructure on'
      end
    end
  end
end
