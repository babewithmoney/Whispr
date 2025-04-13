# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Reaction.delete_all  # Delete reactions first due to foreign key constraint
Confession.delete_all

# Create sample confessions with varying creation times and reactions
confessions = [
  {
    body: "I secretly love pineapple on pizza 🍕",
    created_at: 2.days.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "I've never watched Star Wars... and at this point I'm too afraid to start 🎬",
    created_at: 1.day.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "Sometimes I pretend to be busy at work by typing random keys on my keyboard 💻",
    created_at: 12.hours.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "I still sleep with my childhood teddy bear 🧸",
    created_at: 6.hours.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "I talk to my plants and I'm convinced they understand me 🌱",
    created_at: 1.hour.ago,
    ip_address: "127.0.0.1"
  },
  # Adding older confessions with varying reactions
  {
    body: "This is an old confession but it went viral! 🚀",
    created_at: 30.days.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "Just a regular old confession from last month 📝",
    created_at: 25.days.ago,
    ip_address: "127.0.0.1"
  },
  {
    body: "This confession is new but nobody noticed it yet 🤫",
    created_at: 30.minutes.ago,
    ip_address: "127.0.0.1"
  }
]

created_confessions = confessions.map do |confession_data|
  Confession.create!(confession_data)
end

# Add reactions with different patterns to test trending
reaction_types = %w[like hug laugh]

created_confessions.each_with_index do |confession, index|
  # Add more reactions to newer confessions to test trending
  num_reactions = case index
                 when 4 then 15  # Most recent plant confession gets lots of reactions
                 when 3 then 8   # Teddy bear confession gets moderate reactions
                 when 2 then 5   # Keyboard confession gets some reactions
                 when 1 then 3   # Star Wars confession gets few reactions
                 when 5 then 50  # Old viral confession gets tons of reactions
                 when 6 then 2   # Old regular confession gets very few reactions
                 when 7 then 0   # New confession gets no reactions
                 else 1          # Pizza confession gets minimal reactions
                 end

  num_reactions.times do |n|
    reaction_type = reaction_types[n % reaction_types.length]
    # Generate unique IP for each reaction
    ip_address = "192.168.#{index + 1}.#{n + 1}"
    
    confession.reactions.create!(
      reaction_type: reaction_type,
      ip_address: ip_address
    )
  end
end

puts "Created #{Confession.count} confessions with #{Reaction.count} reactions"
