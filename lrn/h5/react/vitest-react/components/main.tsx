import React from 'react'
import ReactDOM from 'react-dom/client'
import Link from './Link.tsx'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
    <React.StrictMode>
        <Link page="aaa.co">aaa</Link>
    </React.StrictMode>
)
