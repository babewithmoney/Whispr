# Whispr - Anonymous Confessions Platform

Whispr is a web application that allows users to share anonymous confessions and interact through emoji reactions. Built with Ruby on Rails and styled with Tailwind CSS, it features a responsive masonry layout

## Features

- Anonymous confession sharing
- No account required
- Dark theme UI
- Responsive masonry layout
- Interactive emoji reactions
- Trending confessions

## Prerequisites

Before you begin, ensure you have the following installed:
- Ruby 3.2.0 or higher
- Rails 7.0.0 or higher
- Node.js 18+ and Yarn
- PostgreSQL 13+

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/babewithmoney/Whispr
   cd whispr
   ```

2. **Install Ruby dependencies**
   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies**
   ```bash
   yarn install
   ```

4. **Setup database**
   ```bash
   # Create and setup the database
   rails db:create
   rails db:setup

   # Run migrations
   rails db:migrate

   # (Optional) Load sample data
   rails db:seed
   ```

5. **Start the development server**
   ```bash
   # Start the Rails server
   rails server

   # In a separate terminal, start the asset compilation
   yarn build --watch
   ```

6. **Visit the application**
   Open your browser and navigate to `http://localhost:3000`

## Development

- The application uses Tailwind CSS for styling
- Stimulus.js is used for JavaScript interactions
- PostgreSQL is used as the database

## Rate Limiting

- Users are limited to 3 confessions per day (based on IP address)
- Reactions are limited to one per confession per IP address

## Testing

Run the test suite with:
```bash
rails test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
