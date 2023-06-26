import Image from 'next/image'


export default function Home() {


  const list = [...Array(10).keys()]
  

  
  return (
    <main className='bg-red-400 w-full items-center flex flex-col'>
      <p> hello world!</p>
      <ul 
        className='
          list-disc list-inside w-full text-center
           '>
        {list.map(item=>item=listItem())}
      </ul>
    </main>
  )
}

const listItem = () =>{

  return (
    <li className='px-4 py-2 my-4 bg-yellow-200 rounded-lg mx-8'>
      <a href=''>hello world</a>
    </li>
  )
}