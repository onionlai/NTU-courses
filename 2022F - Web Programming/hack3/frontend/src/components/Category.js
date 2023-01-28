import PropTypes from 'prop-types';
import {
  PieChart, Pie, ResponsiveContainer, Cell,
} from 'recharts';
import { Paper } from '@mui/material';
import Title from './Title';

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

const RADIAN = Math.PI / 180;

function Label({
  x, y, cx, cy, percent, fill, name, value, innerRadius, outerRadius, midAngle,
}) {
  const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
  const x2 = cx + radius * Math.cos(-midAngle * RADIAN);
  const y2 = cy + radius * Math.sin(-midAngle * RADIAN);

  return (
    <>
      <text x={x} y={y} fill={fill} textAnchor={x > cx ? 'start' : 'end'}>
        {`${name} $${value} `}
      </text>
      <text x={x2} y={y2} fill="white" textAnchor={x > cx ? 'start' : 'end'} dominantBaseline="central">
        {`${(percent * 100).toFixed(0)}%`}
      </text>
    </>
  );
}

Label.propTypes = {
  x: PropTypes.number.isRequired,
  y: PropTypes.number.isRequired,
  cx: PropTypes.number.isRequired,
  cy: PropTypes.number.isRequired,
  percent: PropTypes.number.isRequired,
  fill: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  value: PropTypes.number.isRequired,
  innerRadius: PropTypes.number.isRequired,
  outerRadius: PropTypes.number.isRequired,
  midAngle: PropTypes.number.isRequired,
};

export default function Category({ items }) {
  const categories = items.reduce((acc, item) => {
    if (item.category === 'INCOME') return acc;

    if (acc[item.category]) {
      acc[item.category] += item.amount;
    } else {
      acc[item.category] = item.amount;
    }
    return acc;
  }, {});

  const categoryList = Object.keys(categories).map((category) => ({
    name: category.toLowerCase(),
    amount: categories[category],
  })).sort((a, b) => a.amount - b.amount);

  return (
    <Paper className="p-4 h-96">
      <Title>Spending by Category</Title>
      <ResponsiveContainer width="100%" height="100%">
        <PieChart width={400} height={400}>
          <Pie
            dataKey="amount"
            data={categoryList}
            cx="50%"
            cy="50%"
            outerRadius={100}
            label={Label}
          >
            {categoryList.map((entry, index) => (
              <Cell key={`cell-${entry.name}`} fill={COLORS[index]} />
            ))}
          </Pie>
        </PieChart>
      </ResponsiveContainer>
    </Paper>

  );
}

Category.propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape({
    amount: PropTypes.number.isRequired,
    category: PropTypes.string.isRequired,
  })).isRequired,
};
