const Query = {
    items: async (parent, args, {itemModel}) => {
      const items = await itemModel.find().sort();
      return items;
    },
};

export default Query;
