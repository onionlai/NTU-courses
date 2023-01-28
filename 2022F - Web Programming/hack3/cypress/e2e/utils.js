const GRAPHQL_ENDPOINT = "localhost:4000/graphql";

export const WAIT_INTERVAL = 500;
export const FRONTEND_URL = "localhost:3000/";

export const GET_ITEMS_QUERY = `
{
  items{
    id
    name
    category
    amount
    date
    description
  }
}
`;

export const sendQuery = (query) => {
  return cy.request({
    method: "POST",
    url: GRAPHQL_ENDPOINT,
    body: {
      query,
    },
  });
}