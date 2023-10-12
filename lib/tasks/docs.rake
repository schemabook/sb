namespace :docs do
  desc "Build the API docs"
  task build: :environment do
    puts "running the API request specs"
    system('SWAGGER_DRY_RUN=0 RAILS_ENV=test bin/rails rswag:specs:swaggerize')

    puts "building the redoc static file"
    system('npx @redocly/cli build-docs swagger/v1/swagger.yaml')

    puts "moving the redoc static site into the public/api-docs directory"
    system('mv redoc-static.html public/api-docs/index.html')
  end
end
