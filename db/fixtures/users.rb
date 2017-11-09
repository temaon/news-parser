User.seed(:id,
          { id: 1, username: 'admin', email: 'test@example.com', password: 'password', confirmed_at: Time.now },
          { id: 2, username: 'admin2', email: 'test2@example.com', password: 'password', confirmed_at: Time.now }
)