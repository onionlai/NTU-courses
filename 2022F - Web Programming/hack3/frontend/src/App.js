import {
  BrowserRouter,
  Routes,
  Route,
} from 'react-router-dom';

import CssBaseline from '@mui/material/CssBaseline';
import AppFrame from './components/AppFrame';
import Home from './components/Home';
import Analytics from './components/Analytics';

import './index.css';

function App() {
  return (
    <>
      <CssBaseline />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<AppFrame />}>
            <Route path="analytics" element={<Analytics />} />
            <Route path="/" element={<Home />} />
            <Route path="*" element={<h1>Error, Page Not Found</h1>} />
          </Route>
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;
