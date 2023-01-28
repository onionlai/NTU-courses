---
tags: 111-1, web-programming README
---

# 111-1-Web-Hackathon03 README -- Budgetly Light

## Prerequisite

1. If you have not done [preREADME](https://hackmd.io/orEwYTuBRv6AwKWo38DqDg?view) yet, please check it out first.
2. Please sign in to Hackathon #3 through this [Google Form](https://docs.google.com/forms/d/1O5qxNf87v-zQhjQRdUzS2RLRUNC1kDK72dg6dmgwSBU/edit#responses). After you fill in your student ID, name, department and grade, you will see the link to the reference code. **<span style="color: red">YOU NEED TO SUBMIT THE FORM</span>** in order to complete the sign-in. Failure to sign in to the Hackathon will result in deduction in points.
3. The downloaded file should be named "**hack3-ref.zip**". Uncompress it under `hack3/` and check if the structure is identical to the figure shown in 5. (Note: If you see an extra `hack3/` directory under `hack3/`, copy the files under `hack3/hack3/` to `hack3/` instead.)
4. Check the structure of the files/directories under `hack3` and it should be like this:

```
.
├── README.md
├── backend
│   ├── .env.defaults
│   ├── package.json
│   ├── src
│   │   ├── index.js
│   │   ├── models
│   │   │   └── item.js
│   │   ├── mongo.js
│   │   ├── resolvers
│   │   │   ├── Category.js
│   │   │   ├── Date.js
│   │   │   ├── Mutation.js
│   │   │   ├── Query.js
│   │   │   └── Subscription.js
│   │   ├── schema.graphql
│   │   ├── server.js
│   │   └── upload.js
│   └── yarn.lock
├── cypress
│   ├── e2e
│   │   ├── initDB.js
│   │   ├── public-spec.cy.js
│   │   └── utils.js
│   ├── fixtures
│   │   └── example.json
│   └──support
│       ├── commands.js
│       └── e2e.js
├── cypress.config.js
├── docker-compose.yml
├── frontend
│   ├── package.json
│   ├── public
│   │   ├── favicon.ico
│   │   ├── index.html
│   │   ├── logo192.png
│   │   ├── logo512.png
│   │   ├── manifest.json
│   │   └── robots.txt
│   ├── src
│   │   ├── App.js
│   │   ├── components
│   │   │   ├── Analytics.js
│   │   │   ├── AppFrame.js
│   │   │   ├── Balance.js
│   │   │   ├── Category.js
│   │   │   ├── Home.js
│   │   │   ├── ItemFormModal.js
│   │   │   ├── NewItem.js
│   │   │   ├── Row.js
│   │   │   ├── SideBarItems.js
│   │   │   └── Title.js
│   │   ├── utils
│   │   │   └── day.js
│   │   ├── graphql
│   │   │   ├── mutations.js
│   │   │   ├── queries.js
│   │   │   └── subscriptions.js
│   │   ├── App.test.js
│   │   ├── index.css
│   │   ├── index.js
│   │   ├── reportWebVitals.js
│   │   └── setupTests.js
│   ├── .gitignore
│   ├── package.json
│   └── yarn.lock
├── .gitignore
├── .nvmrc
├── LICENSE
├── package.json
└── yarn.lock
```
5. Under `hack3/backend`, edit a new file `.env` based on `.env.defaults`. (Note: Don't push your `.env` to Github, please add `.env` into `.gitignore`. TA will test your program by our own `.env` and DB)

6. Under `hack3`, install the dependencies with the following command:
```bash
yarn
yarn install:all
```

7. Under `hack3`, execute the command below to start backend server at port 4000:

```bash
yarn backend
```

8. Under `hack3`, execute the command below to run frontend APP at port 3000:

```bash
yarn frontend
```
:::info
Note that you should see the initial UI as shown below. However the APP is not working before you work on the TODOs.

![](https://i.imgur.com/gMfnpEj.png)

:::

## Introduction to "**Budgetly Light**"

Hack#3 is a light version of a famous Account Book APP -- **Budgetly** ([APP Store](https://apps.apple.com/tw/app/budgetly/id1499662191) | [Google Play](https://play.google.com/store/apps/details?id=com.budgetly.app&hl=zh_TW&gl=US))

> Budgetly is a money manager for you to monitor your personal budget or cash flow of your business. You can create/upadte/delete income or expense with different categories and see the total balance in analytics. 

## General Rules

1. All you need to write are marked by **TODO**'s. Please check the files we mention in the sub-problems. DO NOT modify codes in any other place, or you will NOT get the points of the problems.
2. Do not modify the frontend UI DOM Structure.
3. Do not use other packages.
4. The database access must be implemented by GraphQL.

:::danger
Failure to follow the rules above will result in deduction of your scores. Please be cautious.
:::

### Grading Rules/Reminders

1. A public testcase is provided for you (in cypress format: `hack3/cypress/e2e/public-spec.cy.js`). It is for your self-test only. When grading, the grading program Gradescope will change the testcases as well as the corresponding solutions.
2. By default, your score on Gradescope will be the last version you submit. However, you can choose any of the versions on Gradescope before the deadline. We will test your selected version if you need to be regraded.
3. Although your code should have been graded by Gradescope during the test, however, you should still push your codes onto the main branch of your GitHub repo `wp1111/hack3` before the end of Hack#3. We will check your codes if needed. Failure to push the code before the deadline will be treated as "no-submission" and your grade will become '0' point


## UI of the completed Frontend APP

![](https://imgur.com/2618q3X.png)

- In the main window shows your expense/income records. If there are records more than a page, you can browse them by clicking on the arrows on the bottom-right corner.
- You can enter the new expense/income in the input box on the top-right corner.
- The **Analytics** side-bar is to show the pie chart of your record (see Sub-problem 2.3)
- Note again, you need to work on the TODOs in order to see the correct UIs. The APP is NOT working before you do it.


## TODOs

:::info
Please note that most of the TODOs are independent. In case you are stuck at certain sub-problem, you are encouraged to move on to others ASAP.
:::

### 1. Connect to your MongoDB and call "dataInit()" (25%)

- Files to be modified: `backend/src/mongo.js`、`backend/.env`
- Reminder: You need to have `.env` under `backend` in order to connect to MongoDB.
- The function `dataInit()` in `backend/src/upload.js` is to write the initial sample data into your database. It will be called when the backend server is started. 
- You can change the data in `dataInit()` for testing. We will overwrite it when grading.

After you finished TODO#1, you should be able to see the UIs and some initial data on the APP.


### 2. Query (20%)

#### 2.1 Write the GraphQL query string

- Files to be modified: `frontend/src/graphql/queries.js`
- Some of information is not displayed on the page (i.e. amount, data, description), you should modify gql query string to show the full information.

:::info

After you finished TODO#2.1, your frontend will be like:

![](https://imgur.com/2618q3X.png)

:::

#### 2.2 Use the useQuery hook to get from backend

- Files to be modified: `frontend/src/components/Analytics.js`
- Modify `Analytics` by applying `useQuery` to get the items stored in the backend.
- Store the data in `Analytics()` as a variable named `items`
- [Hint] For the correct usage of `useQuery` (as well as other GraphQL hooks), you can refer to other codes under `src/components`

#### 2.3 Add Balance and Category

- Files to be modified: `frontend/src/components/Analytics.js`

- You don't need to write extra codes except for uncommenting the following lines:
```javascript
 19       {/* <div className="col-span-6">
 20         <Balance items={items} />
 21       </div>
 22       <div className="col-span-6">
 23         <Category items={items} />
 24       </div> */}

```

:::info

After you finish TODO#2.3, you can see the analytics from the `Analytics` side-bar as:

![](https://imgur.com/8VN7CFI.png) 

:::


### 3. Mutation - Create items (20%)

#### 3.1 Write GraphQL mutation string

- Files to be modified: `frontend/src/graphql/mutations.js`.
- Create and finish the gql string `CREATE_ITEM_MUTATION` for the `CreateItem` mutation.

#### 3.2 Evoke the CreateItem Mutation

- Files to be modified: `frontend/src/components/NewItem.js`.
- Apply `useMutation` hook to create the callback function `createItem`.

#### 3.3 Apply the `createItem` callback function
- Files to be modified: `frontend/src/components/NewItem.js`.
- Uncomment the following codes to apply the `createItem` function. You don't need to write extra codes.

```javascript
 29     // TODO 3.2 Uncomment the following code
 30     /*
 31     createItem({
 32       variables: {
 33         input: {
 34           id: uuidv4(),
 35           ...formData,
 36         },
 37       },
 38     });
 39     */
 40     // TODO 3.2 End
 41   };

```

:::info
After you finish TODO#3.3, you should be able to create new expense/income item for this APP.
:::


### 4. Mutation - Update items (10%)

- Files to be modified: `frontend/src/components/Row.js`
- To update an expense/income iten, you need to call `updateItem` in `Row.js` by passing in the correct parameters
- Something is lost in the `handleSubmitEdit` function, you should add them back to finish the update function.
- [Hint] Read `mutation.js` & `schema.graphql` to understand the definition of `updateItem`.


### 5. Mutation - Delete items (15%)

#### 5.1 Define the schema for the deleteItem Mutation

- Files to be modified: `backend/src/schema.graphql`
- Define the schema for the `deleteItem` mutation
  - name: `deleteItem`
  - params: `id: ID!` (item id you what to delete)
  - return: `ID!` (deleted item id)

#### 5.2 Define Mutation resolver

- Files to be modified: `backend/src/resolvers/Mutation.js`
- Define the `deleteItem` mutation resolver:
  - need `itemModel` & `id` to delete the corresponding item
  - return: `id` for the deleted item


### 6. Subscription - delete item (10%)

In this part, we need to add subscription functions for itemDeleted. 

#### 6.1 Define the schema for the deleteItem Subscription

- Files to be modified: `backend/src/schema.graphql`
- Define the schema for the `itemDeleted` subscription 
  - name: `itemDeleted`
  - return: `ID!`

#### 6.2 Define the `itemDeleted` subscription resolver (Backend)

- Files to be modified: `backend/src/resolvers/Subscription.js`
- Define the `itemDeleted` subscription resolver

#### 6.3 Publish itemDeleted (Backend)

- Files to be modified: `backend/src/resolvers/Mutation.js`
- Modify `deleteItem` resolver function to pulish the information.
- [Hint]: read `schema.graphql` to check the input/output type.

#### 6.4 Write GraphQL subscription string (Frontend)

- Files to be modified： `frontend/src/graphql/subscriptions.js`
- Create and finish the gql string for `ITEM_DELETED_SUBSCRIPTION`

#### 6.5 Logic of subscription (Frontend)

- Files to be modified: `frontend/src/components/Home.jsx`
- Apply the `subscribeToMore` function to update the display items by the itemDeleted subscription.

:::info
After you finish TODO#6, you can test subscription by applying mutation on one page and observe the automatic update on another page.
:::

## Running Cypress Tests (Optional)

Before running the tests, please check whether your frontend and backend are successfully run on `localhost:3000` and `localhost:4000`, and then execute the following command under `wp1111/hack3`.

```bash
yarn test 
```

## Submission

### Gradescope submission
- Use the following commands to generate `hack3.zip` under `hack3`
```bash
cd wp1111
git add hack3
git commit -m "hack3"
git archive -o hack3.zip HEAD:hack3
```
- You should see a `hack3.zip` under the `wp111` directory
- Select `hack3` in the GradeScope and upload this `hack3.zip` (Warning: DO NOT get confused with the original ref code `hack3-ref.zip`)
- Wait for a few minutes, you will see the grade for the latest submission

:::info
The grade on Gradescope will be the final score of your Hack#3.
:::

### GitHub submission

Please push your final version of codes onto your GitHub repo `main` branch before the end of Hack#3. We will check your codes if needed. Failure to push the code before the deadline will be treated as "no-submission" and your grade will become '0' point.

```bash
cd wp1111
git add hack3
git commit -m "COMMIT_MESSAGE"
git push
```

### For Q&As

If you encounter any problem or have any question regarding to this Hack#3, you can raise a GitHub issue on [this repo](https://github.com/ntuee-web-programming/111-1_WebProgramming-Hack3_QA). However, before you do so, please:

1. Check if there is any similar issue. If so, read it first and if you still have any question, add it as a comment of this issue. 
2. If you like to raise a new issue, make the title clear and **push your code to GitHub first**. Without your code, we won't be able to identify the potential problems.