import postgres from "postgres";

    const sql = postgres({
      host: 'three-tier-web-app-aurora-cluster.cluster-ce7kmyk8ebyy.us-east-1.rds.amazonaws.com',
      port: 5432,
      username: 'postgres',
      password: 'mysecretpassword',
      database: 'bun_db'
    })

    export default sql;