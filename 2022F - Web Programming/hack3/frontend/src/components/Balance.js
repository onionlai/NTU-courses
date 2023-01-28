import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import Title from './Title';

function Balance({ items }) {
  const total = items.reduce((acc, item) => {
    if (item.category === 'INCOME') {
      return acc + item.amount;
    }
    return acc - item.amount;
  }, 0);

  const thisMonth = items.reduce((acc, item) => {
    const date = new Date(item.date);
    if (date.getMonth() === new Date().getMonth()) {
      if (item.category === 'INCOME') {
        return acc + item.amount;
      }
      return acc - item.amount;
    }
    return acc;
  }, 0);

  return (
    <Paper className="p-4 h-full">
      <Title>Balance</Title>
      <div className="p-8 flex flex-col gap-8">
        <BalanceItem label="Total:" amount={total} />
        <BalanceItem label="This Month:" amount={thisMonth} />
      </div>
    </Paper>
  );
}

Balance.propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape({
    amount: PropTypes.number.isRequired,
    category: PropTypes.string.isRequired,
  })).isRequired,
};

function BalanceItem({ label, amount }) {
  return (
    <div>
      <Typography
        variant="h5"
        component="h2"
        >
        {label}
      </Typography>
      <Typography
        variant="h4"
        className="text-center"
        data-cy="balance-item-amount"
        sx={{
          color: amount >= 0 ? 'success.main' : 'error.main',
        }}
      >
        {`$${amount}`}
      </Typography>
    </div>

  );
}

BalanceItem.propTypes = {
  label: PropTypes.string.isRequired,
  amount: PropTypes.number.isRequired,
};

export default Balance;
