import React, { useState } from 'react';
import { v4 as uuidv4 } from 'uuid';

import { useMutation } from '@apollo/client';
import { useHotkeys } from 'react-hotkeys-hook';

import AddIcon from '@mui/icons-material/Add';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';

import ItemFormModal from './ItemFormModal';

import { CREATE_ITEM_MUTATION } from '../graphql/mutations';

function NewItem() {
  const [open, setOpen] = useState(false);

  // TODO 3.2 Evoke the CreateItem Mutation
  const [createItem] = useMutation(CREATE_ITEM_MUTATION);

  // TODO 3.2 End

  const handleOpen = () => {
    setOpen(true);
  };

  useHotkeys('ctrl+k, ', handleOpen, []);

  const handleSubmit = (formData) => {
    // TODO 3.3 Apply the `createItem` callback function

    createItem({
      variables: {
        input: {
          id: uuidv4(),
          ...formData,
        },
      },
    });

    // TODO 3.3 End
  };

  return (
    <>
      <button
        type="button"
        onClick={handleOpen}
        data-cy="new-item-button"
      >
        <Paper
          className="px-3 py-2"
          sx={{
            borderRadius: '0.5rem',
            transition: 'background-color 0.2s ease-in-out',
            '&:hover': {
              bgcolor: (theme) => theme.palette.grey[300],
            },
          }}
        >
          <div className="flex flex-row items-center gap-2 pr-2">
            <AddIcon />
            <Typography sx={{ color: (theme) => theme.palette.text.disabled }}>
              add new item
            </Typography>
            <div className="text-xs rounded border-grey-200 border-[1px] py-1 px-2 ml-8">
              ctrl + K
            </div>
          </div>
        </Paper>
      </button>
      <ItemFormModal
        open={open}
        title="Add new item"
        handleClose={() => {
          setOpen(false);
        }}
        onSubmit={handleSubmit}
      />
    </>
  );
}

export default NewItem;
