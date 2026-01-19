# README

Schemabook is focused on three things:

- A schema registry (beyond just events)
- Data Contracts (both emerging standards)
- Stakeholder collaboration

Schemabook’s philosophy is simple. When stakeholders collaborate on the definition of data, quality improves, and data becomes more actionable.

Schemabook promises to make all of your organization’s stakeholders feel confident that the data is usable.

![Screenshot](./public/schemabook_screenshot.png)

## Introducing Schemabook

Schemabook’s ultimate goal is to make data more actionable. While building a central component of the data platform at a Fortune 100 company, 
Schemabook’s founder noticed that a lot of effort and cost went into collecting data that the business could not immediately act on. The 
data was collected and possibly even transformed but either just sat in a lake occupying space or required additional institutional knowledge 
to be useful. The issue was not related to the technologies used, nor the architecture. It was a people and process problem. Not all of the 
stakeholders were on the same page. Many times they didn’t know each other or weren’t even aware of each other.

How can data producers confidently deliver data that consumers need to perform their responsibilities? How can consumers make requests of 
the producers when they can’t identify them? The outcome everyone is looking for is grounded in stakeholders collaborating. Schemabook is a 
data stakeholder collaboration product.

Schemabook revolves around the idea of declared schemas, but it’s not just a central schema registry. It helps stakeholders stay on the same 
page and provides a space for data contracts to be defined and shared. It offers tooling for engineering teams to ensure the quality of the 
data they produce and consume. Stakeholders can easily identify themselves without a burdensome process, and changes to data can be discussed 
and prepared ahead of time, preventing downtime and data loss.

If your stakeholders don’t know one another or are not collaborating on defining the data needed to accelerate your business, please give 
Schemabook a try. Don’t just dump data in a lake or warehouse without knowing its purpose. We believe our lightweight approach can help you 
turn the page on the story of data in your organization.

Schemabook aims to make data more actionable by addressing the lack of collaboration among stakeholders in data management. The founder of 
Schemabook observed that despite efforts to collect and transform data at a Fortune 100 company, the data often went unused due to a lack of 
communication and shared understanding among stakeholders. This issue was not due to technological limitations, but rather a disconnect in 
processes and communication.

To address this challenge, Schemabook offers a platform for stakeholders to declare schemas and define data contracts, fostering 
collaboration and ensuring that data producers deliver the information that consumers need. By providing tools for engineering teams to 
maintain data quality and facilitating discussions around changes to data, Schemabook eliminates the risk of downtime and data loss.

If your organization struggles with disconnected stakeholders and inefficient data management processes, consider giving Schemabook a try. 
Rather than simply storing data in a repository without purpose, Schemabook offers a solution to streamline data management and drive 
business growth. Take the first step towards improved collaboration and data utilization with Schemabook’s innovative approach.

## Getting Started

All that should be needed is:

`git clone`

`bundle`

`rails db:create`
`rails db:migrate`

`bundle exec rspec`

`./bin/dev`

`./bin/rails s` # for pry support

## Emails

Generate a mailer, and style to match:

http://localhost:3000/rails/mailers/user/welcome_email.html?locale=en

## Storage

Production storage is on disk at Render
