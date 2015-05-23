namespace :projects do
  task recreate_index: :environment do
    # If the index doesn't exists can't be deleted, returns 404, carry on
    Project.__elasticsearch__.client.indices.delete index: 'projects' rescue nil
    Project.__elasticsearch__.create_index! force: true
  end

  task reindex: [:environment, :recreate_index] do
    Project.import query: -> { includes(:github_repository => :github_tags) }
  end

  desc 'Update the sitemap every other day'
  task update_sitemap: :environment do
    if Date.today.wday.even?
      Rake::Task["sitemap:refresh"].invoke
    end
  end

  task update_source_ranks: :environment do
    Project.where('updated_at > ?', 1.week.ago).find_each(&:update_source_rank_async) if Date.today.sunday?
  end

  task link_dependencies: :environment do
    Dependency.without_project_id.find_each(&:update_project_id)
  end
end
