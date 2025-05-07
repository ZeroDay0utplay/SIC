# Ideo Groupe

## Introduction

Ideo Groupe is a Ruby on Rails application designed for efficient and scalable web development. This README provides instructions for setting up and running the project using both Docker and a traditional setup.

---

## Prerequisites

- Docker and Docker Compose installed on your system.
- Ruby (version specified in the Gemfile).
- Node.js and Yarn.
- PostgreSQL (if not using Docker).

---

## Setup

### Environment Variables

Create a `.env` file in the root directory with the following environment variables:

```
POSTGRES_DB=your_database_name
POSTGRES_USER=your_database_user
POSTGRES_PASSWORD=your_database_password
SECRET_KEY_BASE=your_secret_key
DATABASE_URL=postgresql://your_database_user:your_database_password@db:5432/your_database_name
```

Replace your_database_name, your_database_user, your_database_password, and your_secret_key with your actual values.

To generate the SECRET_KEY_BASE, run:

```
rails secret
```

Copy the generated string and paste it into the SECRET_KEY_BASE variable in your `.env` file.

## Running the Project
### Using Docker

1. Build and Start Containers:

```
docker compose up --build
```
2. Access the Application:

- The application will be available at
```
http://localhost:3000
```

3. Run Database Migrations:

```
docker compose exec app bin/rails db:create db:migrate db:seed
```