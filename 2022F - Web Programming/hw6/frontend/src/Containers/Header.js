import styled from 'styled-components';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

import axios from '../api';
import { useScoreCard } from '../hooks/useScoreCard';

const Wrapper = styled.section`
  display: flex;
  align-items: center;
  justify-content: center;

  & button {
    margin-left: 3em;
  }
`;

const Header = () => {
  const { clearMessages } = useScoreCard();

  const handleClear = async () => {
    try {
      const {
        data: { message },
      } = await axios.delete('/cards');
      clearMessages(message);
    } catch (e) {
      try {
        console.log(e.response.data.message);
      } catch (ee) {
        alert('Server Down. Try later...');
      }
    }
  };

  return (
    <Wrapper>
      <Typography variant="h2">ScoreCard DB</Typography>
      <Button variant="contained" color="secondary" onClick={handleClear}>
        Clear
      </Button>
    </Wrapper>
  );
};

export default Header;
