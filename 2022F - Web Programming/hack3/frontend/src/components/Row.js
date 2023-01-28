import { useState } from 'react';
import PropTypes from 'prop-types';

import TableCell from '@mui/material/TableCell';
import TableRow from '@mui/material/TableRow';
import Typography from '@mui/material/Typography';
import Collapse from '@mui/material/Collapse';
import IconButton from '@mui/material/IconButton';

import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';

import dayjs from '../utils/day';
import ItemFormModal from './ItemFormModal';

function Row({
  item, updateItem, deleteItem,
}) {
  const [descriptionOpen, setDescriptionOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);

  const onCollapse = () => {
    setDescriptionOpen((open) => !open);
  };

  const onEdit = () => {
    setEditOpen((open) => !open);
  };

  const handleDelete = () => {
    deleteItem({
      variables: {
        id: item.id,
      },
      onError: (err) => {
        // eslint-disable-next-line no-console
        console.error(err);
      },
    });
  };

  const handleSubmitEdit = (formData) => {
    console.log("here item is", item);
    console.log("here formData is", formData);
    updateItem({
      variables: {
        // TODO 4 Use `updateItem` and pass the correct variables
        input: {
          id: item.id,
          amount: formData.amount,
          category: formData.category,
          data: formData.data,
          description: formData.description,
          name: formData.name
        },
        // TODO End
        onError: (err) => {
          // eslint-disable-next-line no-console
          console.error(err);
        },
      },
    });
  };

  return (
    <>
      <TableRow data-cy="item" key={item.id} hover>
        <TableCell onClick={onCollapse} sx={{ cursor: 'pointer' }}>
          <Typography>{item.date && dayjs(item.date).calendar()}</Typography>
        </TableCell>
        <TableCell data-cy="item-name" onClick={onCollapse} sx={{ cursor: 'pointer' }}>
          <Typography>{item.name}</Typography>
        </TableCell>
        <TableCell data-cy="item-amount" align="right">
          <Typography>{item.amount && `$${item.amount}`}</Typography>
        </TableCell>
        <TableCell data-cy="item-category" onClick={onCollapse} sx={{ cursor: 'pointer' }}>
          <Typography>{item.category?.toLowerCase()}</Typography>
        </TableCell>
        <TableCell align="right" data-cy="item-edit">
          <IconButton onClick={onEdit} data-cy="update-item">
            <EditIcon />
          </IconButton>
          <IconButton onClick={handleDelete} data-cy="delete-item">
            <DeleteIcon />
          </IconButton>
        </TableCell>
      </TableRow>
      <TableRow key={`${item.id}-descriptions`}>
        <TableCell colSpan={5} style={{ paddingTop: 0, paddingBottom: 0 }}>
          <Collapse in={descriptionOpen} timeout="auto" unmountOnExit>
            <div className="p-4">
              <Typography gutterBottom>
                Descriptions
              </Typography>
              <Typography variant="subtitle2" sx={{ textIndent: '1rem' }}>{item.description || 'No description'}</Typography>
            </div>
          </Collapse>
        </TableCell>
      </TableRow>
      <ItemFormModal
        title="Edit Item"
        open={editOpen}
        handleClose={() => setEditOpen(false)}
        onSubmit={handleSubmitEdit}
        defaultFormData={item}
      />
    </>
  );
}

Row.propTypes = {
  item: PropTypes.shape({
    id: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    amount: PropTypes.number.isRequired,
    category: PropTypes.string.isRequired,
    date: PropTypes.number.isRequired,
    description: PropTypes.string,
  }).isRequired,
  updateItem: PropTypes.func.isRequired,
  deleteItem: PropTypes.func.isRequired,
};

export default Row;
