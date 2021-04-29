# Contact Importer

This project allows you to import your contact list from a CSV file that contains dynamic header names.

## How to run locally

Prepare your local environment:

```bash
git clone https://github.com/seccomiro/contact-importer.git
cd contacts-deploy
cp .env.example .env
rails db:create db:migrate db:seed
```

Don't forget to configure your database connection at `.env`.

Run the application:

```bash
bundle exec sidekiq
rails s
```

⚠️ Warning:

> You'll need PostgreSQL and Redis already installed.

Access the application:

Open http://localhost:3000 in your browser.

## Default User

- Email: user@user.com

- Password: 321321321

## Example CSV files

Example CSV files can be found at `csv_examples` folder.

## Running Application

This application is deployed to: https://csv-contact-importer.herokuapp.com.

## To Do

- Add more tests. Because of lack time to finish this feature, it was possible to tackle only the core credit card validation logic.
- Upload files to AWS S3 instead of temp files.
- Improve some validations
- Dates are not being validated yet.