import React, { useState, useMemo } from 'react';
import PropTypes from 'prop-types';

import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogTitle from '@mui/material/DialogTitle';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import FormControl from '@mui/material/FormControl';
import Grow from '@mui/material/Grow';
import Input from '@mui/material/Input';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import Select from '@mui/material/Select';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';

function HelperText({ color, children }) {
  return (
    <Typography color={color} variant="caption">
      {children}
    </Typography>
  );
}

HelperText.propTypes = {
  color: PropTypes.string,
  children: PropTypes.node.isRequired,
};

HelperText.defaultProps = {
  color: 'default',
};

// eslint-disable-next-line react/jsx-props-no-spreading
const Transition = React.forwardRef((props, ref) => <Grow ref={ref} {...props} unmountOnExit />);

function ItemFormModal({
  open, handleClose, title, onSubmit, defaultFormData,
}) {
  const sanitizedDefaultFormData = useMemo(() => ({
    name: defaultFormData.name ?? '',
    amount: defaultFormData.amount ?? 0,
    category: defaultFormData.category ?? 'FOOD',
    date: defaultFormData.date ?? Date.now(),
    description: defaultFormData.description ?? '',
  }), [defaultFormData]);

  const [formData, setFormData] = useState(sanitizedDefaultFormData);

  const [errors, setErrors] = useState({
    name: false,
    amount: false,
  });

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleDateChange = (date) => {
    setFormData((prev) => ({
      ...prev,
      date,
    }));
  };

  const onClose = () => {
    setFormData(sanitizedDefaultFormData);

    setErrors({
      name: false,
      amount: false,
    });

    handleClose();
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();
    // name and amount are required
    if (formData.name === '' || formData.amount === '') {
      setErrors({
        name: !formData.name,
        amount: !formData.amount,
      });
      return;
    }
    const parsedFormData = {
      ...formData,
      amount: parseInt(formData.amount, 10),
    };
    onSubmit(parsedFormData);

    handleClose();
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      TransitionComponent={Transition}
    >
      <DialogTitle>
        {title}
      </DialogTitle>
      <DialogContent sx={{ width: 600 }}>
        <div className="flex flex-col gap-4 px-10">
          <FormControl variant="filled">
            <Input
              name="name"
              placeholder="Item name"
              autoFocus
              onChange={handleInputChange}
              required
              size="medium"
              defaultValue={sanitizedDefaultFormData.name}
              data-cy="form-name"
            />
            {errors.name && <HelperText color="error">Name is required</HelperText>}
          </FormControl>
          <FormControl sx={{ width: 200 }}>
            <Input
              name="amount"
              type="number"
              placeholder="amount"
              onChange={handleInputChange}
              required
              defaultValue={sanitizedDefaultFormData.amount}
              data-cy="form-amount"
            />
            {errors.amount && <HelperText color="error">Amount is required</HelperText>}
          </FormControl>
          <FormControl sx={{ width: 200 }}>
            <InputLabel id="category-select-label">Category</InputLabel>
            <Select
              name="category"
              label="Category"
              labelId="category-select-label"
              defaultValue={sanitizedDefaultFormData.category}
              onChange={handleInputChange}
              data-cy="form-category"
            >
              <MenuItem value="FOOD">Food</MenuItem>
              <MenuItem value="TRANSPORT">Transport</MenuItem>
              <MenuItem value="HOUSING">Housing</MenuItem>
              <MenuItem value="UTILITIES">Utilities</MenuItem>
              <MenuItem value="HEALTH">Health</MenuItem>
              <MenuItem value="ENTERTAINMENT">Entertainment</MenuItem>
              <MenuItem value="CLOTHING">Clothing</MenuItem>
              <MenuItem value="EDUCATION">Education</MenuItem>
              <MenuItem value="OTHER">Other</MenuItem>
              <MenuItem value="INCOME">Income</MenuItem>
            </Select>
          </FormControl>
          <FormControl>
            <LocalizationProvider dateAdapter={AdapterDayjs}>
              <DateTimePicker
                // eslint-disable-next-line react/jsx-props-no-spreading
                renderInput={(props) => <TextField {...props} name="date" />}
                label="Date"
                onChange={handleDateChange}
              />
            </LocalizationProvider>
          </FormControl>
          <FormControl>
            <TextField
              name="description"
              multiline
              rows={4}
              placeholder="description" onChange={handleInputChange}
              data-cy="form-description"
            />
          </FormControl>
        </div>
      </DialogContent>
      <DialogActions sx={{ p: 2 }}>
        <Button
          variant="contained"
          onClick={handleClose}
          color="error"
          tabIndex={-1}
        >
          Cancel
        </Button>
        <Button
          variant="contained"
          onClick={handleSubmit}
          data-cy="form-submit"
        >
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}

ItemFormModal.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func.isRequired,
  title: PropTypes.string.isRequired,
  onSubmit: PropTypes.func,
  defaultFormData: PropTypes.shape({
    name: PropTypes.string,
    amount: PropTypes.number,
    category: PropTypes.string,
    date: PropTypes.number,
    description: PropTypes.string,
  }),
};

ItemFormModal.defaultProps = {
  open: false,
  onSubmit: () => {},
  defaultFormData: {
    name: '',
    amount: 0,
    category: 'FOOD',
    date: Date.now(),
    description: '',
  },
};

export default ItemFormModal;
