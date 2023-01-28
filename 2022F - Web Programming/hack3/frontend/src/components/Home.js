import { useState, useEffect } from 'react';
import { useQuery, useMutation } from '@apollo/client';

import Paper from '@mui/material/Paper';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableHead from '@mui/material/TableHead';
import TableCell from '@mui/material/TableCell';
import TableRow from '@mui/material/TableRow';
import TableFooter from '@mui/material/TableFooter';
import TablePagination from '@mui/material/TablePagination';

import { GET_ITEMS_QUERY } from '../graphql/queries';
import { UPDATE_ITEM_MUTATION, DELETE_ITEM_MUTATION } from '../graphql/mutations';
import {
  ITEM_CREATED_SUBSCRIPTION,
  ITEM_UPDATED_SUBSCRIPTION,
  ITEM_DELETED_SUBSCRIPTION,
} from '../graphql/subscriptions';

import Title from './Title';
import Row from './Row';

function Home() {
  const {
    loading, error, data: itemsData, subscribeToMore,
  } = useQuery(GET_ITEMS_QUERY);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [updateItem] = useMutation(UPDATE_ITEM_MUTATION);
  const [deleteItem] = useMutation(DELETE_ITEM_MUTATION);

  useEffect(
    () => {
      subscribeToMore({
        document: ITEM_CREATED_SUBSCRIPTION,
        updateQuery: (prev, { subscriptionData }) => {
          if (!subscriptionData.data) return prev;
          const item = subscriptionData.data.itemCreated;
          return {
            items: [item, ...prev.items],
          };
        },
      });
    },
    [subscribeToMore],
  );

  useEffect(
    () => {
      subscribeToMore({
        document: ITEM_UPDATED_SUBSCRIPTION,
        updateQuery: (prev, { subscriptionData }) => {
          if (!subscriptionData.data) return prev;
          const updatedItem = subscriptionData.data.itemUpdated;
          return {
            items: prev.items.map((item) => (item.id === updatedItem.id ? updatedItem : item)),
          };
        },
      });
    },
    [subscribeToMore],
  );

  // TODO 6.5 Logic of subscription
  useEffect(
    () => {
      subscribeToMore({
        document: ITEM_DELETED_SUBSCRIPTION,
        updateQuery: (prev, { subscriptionData }) => {
          console.log("deleted subs");

          if (!subscriptionData.data) return prev;
          const deletedId = subscriptionData.data.itemDeleted;
          console.log(deletedId); //@todo
          return {
            items: prev.items.filter(item => item.id !== deletedId)
          };
        },
      });
    },
    [subscribeToMore],
  );
  // TODO 6.5 End

  if (loading) return <p>Loading...</p>;
  if (error) {
    // eslint-disable-next-line no-console
    console.error(error);
    return (<p>Error :(</p>);
  }

  const { items } = itemsData;
  const sortedItems = items.slice().sort((a, b) => b.date - a.date);

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

  const handleRowsPerPageChange = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  return (
    <Paper className="p-4">
      <Title>Recent Records</Title>
      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell variant="head">Date</TableCell>
            <TableCell variant="head">Name</TableCell>
            <TableCell variant="head" align="right">Amount</TableCell>
            <TableCell variant="head">Category</TableCell>
            <TableCell variant="head" />
          </TableRow>
        </TableHead>
        <TableBody>
          {sortedItems.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
            .map((item) => (
              <Row
                key={item.id}
                item={item}
                updateItem={updateItem}
                deleteItem={deleteItem}
              />
            ))}
        </TableBody>
        <TableFooter>
          <TableRow>
            <TablePagination
              rowsPerPageOptions={[5, 10, 25]}
              count={items.length}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={handlePageChange}
              onRowsPerPageChange={handleRowsPerPageChange}
            />
          </TableRow>
        </TableFooter>
      </Table>
    </Paper>
  );
}

export default Home;
