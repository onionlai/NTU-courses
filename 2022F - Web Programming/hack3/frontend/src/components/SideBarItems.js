import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import HomeIcon from '@mui/icons-material/Home';
import LeaderboardIcon from '@mui/icons-material/Leaderboard';
import { Link, useLocation } from 'react-router-dom';

const items = [
  {
    name: 'Home',
    icon: <HomeIcon />,
    to: '/',
  },
  {
    name: 'Analytics',
    icon: <LeaderboardIcon />,
    to: '/analytics',
  },
];

function SideBarItems() {
  const location = useLocation();
  const currentPath = location.pathname;

  return (
    <>
      {
        items.map((item) => (
          <ListItemButton
            key={item.name}
            component={Link}
            to={item.to}
            selected={currentPath === item.to}
          >
            <ListItemIcon>
              {item.icon}
            </ListItemIcon>
            <ListItemText primary={item.name} />
          </ListItemButton>
        ))
      }
    </>
  );
}

export default SideBarItems;
