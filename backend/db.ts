import postgres from "postgres";

    const sql = postgres({
      host: 'some-postgres.orb.local',
      port: 5432,
      username: 'postgres',
      password: 'mysecretpassword',
      database: 'bun_db'
    })

    export default sql;