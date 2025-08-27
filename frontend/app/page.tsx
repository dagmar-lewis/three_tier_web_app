
async function getData() {
  const res = await fetch('http://localhost:3000/'); // Replace with your API endpoint
  if (!res.ok) {
    throw new Error('Failed to fetch data');
  }
  return res.json();
}

export default async function Home() {
  const data = await getData()

  return (
    <div>
      
      <ul>
        {
          data.map((data) =>(
            <li key={data.id}>{data.id}. {data.name} | {data.email}</li>
          ))
        }
      </ul>
      
    
    </div>
  );
}
