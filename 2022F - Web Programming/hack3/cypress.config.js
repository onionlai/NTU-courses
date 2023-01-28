const { defineConfig } = require("cypress");

module.exports = defineConfig({
  trashAssetsBeforeRuns: true,
  screenshotOnRunFailure: true,
  video: false,

  e2e: {
    async setupNodeEvents(on, config) {
      on('task', {
        initDB(examples) {
          const initDB = require("./cypress/e2e/initDB.js");

          return new Promise((resolve, reject) => {
            initDB(examples)
              .then(
                (result) => {
                  resolve(result);
                }
              )
              .catch((err) => {
                console.error({err});
                reject(err);
              });
          });
        },
        log(message) {
          console.log(message)
          return null
        },
      })
    },
  },
});
