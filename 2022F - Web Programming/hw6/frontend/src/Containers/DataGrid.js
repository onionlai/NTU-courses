import React from "react";
import { DataGrid, gridNumberComparator } from "@mui/x-data-grid";

const columns = [
  { field: "name", headerName: "Name", width: 200},
  { field: "subject", headerName: "Subject", width: 200},
  { field: "score", headerName: "Score", width: 100, sortComparator: gridNumberComparator}
];

const DataGridScoreCard = ({ data }) => {
  return (
    <DataGrid sx={{minHeight: "500px"}}
      columns={columns}
      rows={data}
      getRowId = {(row) => row.name + "###" + row.subject}
      pageSize={10}
    />
  );

};

export default DataGridScoreCard;
