import { useState, useEffect } from 'react';
import Button from '@mui/material/Button';
import { FormControl, FormControlLabel } from '@mui/material';
import Paper from '@mui/material/Paper';
import { Radio, RadioGroup } from '@mui/material';
import styled from 'styled-components';
import TextField from '@mui/material/TextField';
import { Tab, Tabs } from '@mui/material';
import Typography from '@mui/material/Typography'
import { useStyles } from '../hooks';
import axios from '../api';
import { useScoreCard } from '../hooks/useScoreCard';
import DataGrid from './DataGrid'
import QueryTable from './QueryTable'

const Wrapper = styled.section`
  display: flex;
  flex-direction: column;
`;

const Row = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 1em;
`;

const StyledFormControl = styled(FormControl)`
  min-width: 120px;
  // width: 100%;
`;

const ContentPaper = styled(Paper)`
  height: 800px;
  padding: 1em 2em;
  margin: 1em 0em;
  overflow: auto;
  width: 60vw;
`;

const Body = () => {
  const classes = useStyles();

  const { messages, addCardMessage, addRegularMessage, addErrorMessage } =
    useScoreCard();

  const [name, setName] = useState('');
  const [subject, setSubject] = useState('');
  const [score, setScore] = useState(0);

  const [queryType, setQueryType] = useState('name');
  const [queryString, setQueryString] = useState('');
  const [queryResult, setQueryResult] = useState([]);
  const [showQueryTable, setShowQueryTable] = useState(false);

  const [tabIndex, setTabIndex] = useState(0);
  const [data, setData] = useState([]);

  // [Funny] useEffect( () => handleInit(), []) 這樣寫的話會違反useEffect中有async await, 下面那樣就不會
  useEffect( () => {
    handleGetData();
  }, [])

  const handleGetData = async () => {
    try {
      const { data: {data} } = await axios.get('/data');
      setData(data);
      console.log(data);
    } catch (e) {
      try {
        console.log(e.response.data.message);
      } catch (ee) {
        alert('Server Down. Try later...');
      }
    }
  };

  const handleError = (e) => {
    try {
      console.log(e.response.data.message);
    } catch (ee) {
      alert('Server Down. Try later...');
    }
  }

  const handleChange = (func) => (event) => {
    func(event.target.value);
  };

  const handleAdd = async () => {
    try {
      const {
        data: { message, card, update }
      } = await axios.post('/card', {
        name,
        subject,
        score,
      }); // 注意，await完之後不宜再使用name, subject, score
      // 會有race condition
      setShowQueryTable(false);

      if (card) {
        addCardMessage(message);
        if (!update) setData([...data, card]); // todo . update one
        else setData(data.map(d => d.name === card.name && d.subject === card.subject ? card : d));
      }
      setName('');
      setSubject('');
      setScore('');

    } catch (e) {
      handleError(e);
    }
  };

  const handleQuery = async () => {
    try {
      const {
        data: { messages, message, queryCards },
      } = await axios.get('/cards', {
        params: {
          type: queryType,
          queryString,
        },
      });

      if (!messages) {
        setShowQueryTable(false);
        addErrorMessage(message);
      }
      else {
        addRegularMessage(...messages);
        setQueryResult(queryCards);
        setShowQueryTable(true);
      }

      setQueryString('');
    } catch(e) {
      handleError(e);
    }
  };



  return (
    <Wrapper>
      <Tabs value={tabIndex} onChange={(e, id) => setTabIndex(id)} centered>
        <Tab label="Add" />
        <Tab label="Query" />
      </Tabs>
      {tabIndex == 0 ? <Row>
        {/* Could use a form & a library for handling form data here such as Formik, but I don't really see the point... */}
        <TextField
          className={classes.input}
          placeholder="Name"
          value={name}
          onChange={handleChange(setName)}
        />
        <TextField
          className={classes.input}
          placeholder="Subject"
          style={{ width: 240 }}
          value={subject}
          onChange={handleChange(setSubject)}
        />
        <TextField
          className={classes.input}
          placeholder="Score"
          value={score}
          onChange={handleChange(setScore)}
          type="number"
        />
        <Button
          className={classes.button}
          variant="contained"
          color="primary"
          disabled={!name || !subject}
          onClick={handleAdd}
        >
          Add
        </Button>
      </Row> :
      <Row>
        <StyledFormControl>
          <FormControl component="fieldset">
            <RadioGroup
              row
              value={queryType}
              onChange={handleChange(setQueryType)}
            >
              <FormControlLabel
                value="name"
                control={<Radio color="primary" />}
                label="Name"
              />
              <FormControlLabel
                value="subject"
                control={<Radio color="primary" />}
                label="Subject"
              />
            </RadioGroup>
          </FormControl>
        </StyledFormControl>
        <TextField
          placeholder="Query string..."
          value={queryString}
          onChange={handleChange(setQueryString)}
          style={{ flex: 1 }}
        />
        <Button
          className={classes.button}
          variant="contained"
          color="primary"
          disabled={!queryString}
          onClick={handleQuery}
        >
          Query
        </Button>
      </Row> }



      {/* <DataGrid data={data}/> */}
      <ContentPaper variant="outlined">
        {messages.map((m, i) => (
          <Typography variant="body2" key={m + i} style={{ color: m.color }}>
            {m.message}
          </Typography>
        ))}
        {showQueryTable && <QueryTable data={queryResult} />}
      </ContentPaper>
    </Wrapper>
  );
};

export default Body;
