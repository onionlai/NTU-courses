import {
  WAIT_INTERVAL,
  FRONTEND_URL,
  GET_ITEMS_QUERY,
  sendQuery,
} from "./utils.js";

const publicExampleData = [
  {
    id: "1",
    name: "brunch",
    amount: 1000,
    date: new Date("2022-12-10T07:00:00.000Z").getTime(),
    category: "FOOD",
    description: "Too expensive.",
  },
  {
    id: "2",
    name: "MRT",
    amount: 30,
    date: new Date("2022-12-07T08:30:00.000Z").getTime(),
    category: "TRANSPORT",
    description: "Go to school.",
  },
  {
    id: "3",
    name: "protection money",
    amount: 1000,
    date: new Date("2022-12-05T12:00:00.000Z").getTime(),
    category: "OTHER",
    description: "",
  },
  {
    id: "4",
    name: "ointment",
    amount: 100,
    date: new Date("2022-12-04T15:00:00.000Z").getTime(),
    category: "HEALTH",
    description: "I broke my leg on my way home QQ.",
  },
  {
    id: "5",
    name: "salary",
    amount: 2000,
    date: new Date("2022-12-03T19:00:00.000Z").getTime(),
    category: "INCOME",
    description: "Math tutor.",
  },
  {
    id: "6",
    name: "1+1",
    amount: 45,
    date: new Date("2022-12-01T19:00:00.000Z").getTime(),
    category: "FOOD",
    description: "1 + 1 = 50 * 0.9",
  },
];

describe('public spec 1. Environment Setup (25%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
  });

  it("1.1 Connect your MongoDB and call dataInit (25%)", () => {
    sendQuery(GET_ITEMS_QUERY).then((response) => {
      expect(response.body.data.items).to.deep.equal(publicExampleData);
    });
  });
})

describe('public spec 2. Query (20%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
  });

  it("2.1 ADD query field to get the full item information (10%)", () => {
    cy.visit(FRONTEND_URL);
    // the value of the item amount should be equal to the value of the item amount in the database
    cy.get("[data-cy=item-amount]").should("have.length", publicExampleData.length);
    cy.get("[data-cy=item-amount]").each(($el, index) => {
      cy.wrap($el).should("have.text",`$${publicExampleData[index].amount}`);
    });
    // the value of the item category should be equal to the value of the item name in the database
    cy.get("[data-cy=item-category]").should("have.length", publicExampleData.length);
    cy.get("[data-cy=item-category]").each(($el, index) => {
      cy.wrap($el).should("have.text", publicExampleData[index].category.toLowerCase());
    });
  });

  it("2.2 Use the useQuery hook to get items from backend (10%)", () => {
    cy.visit(FRONTEND_URL + "analytics");

    const balance = publicExampleData.reduce((acc, item) => {
      if (item.category === "INCOME") {
        return acc + item.amount;
      } else {
        return acc - item.amount;
      }
    }
    , 0);

    cy.get("[data-cy=balance-item-amount]").first().should("have.text", `$${balance}`);
  });
});

describe('public spec 3. Mutation - Create Item (20%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
    cy.visit(FRONTEND_URL);
  });

  const newItem = {
    name: "new item name",
    amount: 100,
    // date: new Date("2022-12-11T07:00:00.000Z").getTime(),
    // category: "FOOD",
    // description: "new item description",
  };

  it("3 Mutation - Create Item (20%)", () => {
    // click the button with the data-cy attribute value of "new-item-button"
    cy.get("[data-cy=new-item-button]").click();

    cy.get("[data-cy=form-name]").clear().type(newItem.name);
    cy.get("[data-cy=form-amount]").clear().type(newItem.amount);

    // press the button with the data-cy attribute value of "form-submit"
    cy.get("[data-cy=form-submit]").click();

    // wait for the item to be created
    cy.wait(WAIT_INTERVAL);

    // the value of the item name should be equal to the new item name
    cy.get("[data-cy=item-name]").should("have.length", publicExampleData.length + 1);
    cy.get("[data-cy=item-name]").first().should("have.text", newItem.name);

    // the value of the item amount should be equal to the new item amount
    cy.get("[data-cy=item-amount]").should("have.length", publicExampleData.length + 1);
    cy.get("[data-cy=item-amount]").first().should("have.text", `$${newItem.amount}`);
  });
});

describe('public spec 4. Mutation - Update Item (10%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
    cy.visit(FRONTEND_URL);
  });

  it("4 Mutation - Update Item (10%)", () => {
    // click the first edit button wrapped by the div with the data-cy attribute value of "item-edit"
    cy.get("[data-cy=update-item]").first().click();
    // clear the input field with the data-cy attribute value of "form-name"
    // and type in the new item name
    cy.get("[data-cy=form-name]").clear().type("new item name");
    // press the button with the data-cy attribute value of "form-submit"
    cy.get("[data-cy=form-submit]").click();

    // wait for the item to be updated
    cy.wait(WAIT_INTERVAL);

    // the value of the item name should be equal to the new item name
    cy.get("[data-cy=item-name]").first().should("have.text", "new item name");
  });
});

describe('public spec 5. Mutation - Delete Item (15%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
    cy.visit(FRONTEND_URL);
  });

  it("5 Mutation - Delete Item (15%)", () => {
    // click the first delete button wrapped by the div with the data-cy attribute value of "item-delete"
    cy.get("[data-cy=delete-item]").first().click();

    // wait for the item to be deleted
    cy.wait(WAIT_INTERVAL);

    // refresh the page
    cy.reload();

    // the number of items should be one less than the number of items in the database
    cy.get("[data-cy=item-name]").should("have.length", publicExampleData.length - 1);
  });
});

describe('public spec 6. Subscription (10%)', () => {
  beforeEach(() => {
    cy.task("initDB", publicExampleData);
    cy.visit(FRONTEND_URL);
  });

  it("6 Subscription (10%)", () => {
    // click the first delete button wrapped by the div with the data-cy attribute value of "item-delete"
    cy.get("[data-cy=delete-item]").first().click();

    // wait for the item to be deleted
    cy.wait(WAIT_INTERVAL);
    
    // the number of items should be one less than the number of items in the database
    cy.get("[data-cy=item-name]").should("have.length", publicExampleData.length - 1);
  });
});
