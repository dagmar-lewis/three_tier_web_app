import sql from './db.ts'
import { serve } from "bun";

await sql`
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
  )
`;

await sql`
    INSERT INTO users (name, email)
      VALUES 
      ('Alice', 'alice@example.com'),
      ('Mark', 'mark@example.com'),
      ('John', 'john@example.com')
    ON CONFLICT (email) DO NOTHING;
`;

const userId = 1
const user = await sql`SELECT * FROM users WHERE id = ${userId}`

serve({
  port: 3000,
  async fetch(req) {
    const users = await sql`SELECT * FROM users`;
    return new Response(JSON.stringify(users), {
      headers: { "Content-Type": "application/json" }
    })
  }
})