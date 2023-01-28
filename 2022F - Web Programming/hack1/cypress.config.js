const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    reporter: "cypress-multi-reporters",
    reporterOptions: {
      reporterEnabled: "mochawesome",
      mochawesomeReporterOptions: {
        reportDir: "cypress/results",
        overwrite: true,
        html: true,
        json: true,
      },
    },
    video: false,
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
