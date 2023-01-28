import React from 'react';
import {
  TableContainer,
  Table,
  TableHead,
  TableRow,
  TableBody,
  TableCell,
  Paper,
} from "@mui/material";

const QueryTable = ({data}) => {
	return (
			<TableContainer component={Paper} sx={{ maxHeight: "300px" }}>
      <Table stickyHeader>
        <TableHead>
          <TableRow>
            <TableCell> Name </TableCell>
            <TableCell> Subject </TableCell>
            <TableCell align="right"> Score </TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {data.map((d) => (
            <TableRow key={d._id}>
              <TableCell> {d.name} </TableCell>
              <TableCell> {d.subject} </TableCell>
              <TableCell align="right"> {d.score} </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>

	)
}

export default QueryTable