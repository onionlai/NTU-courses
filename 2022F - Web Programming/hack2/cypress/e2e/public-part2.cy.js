describe('111-1 WP Hackathon 2 Public Test\n  (25%) Part II - Advanced Search', () => {
    beforeEach(() => {
        cy.wait(200);
    })
    context('( 5%) 1.  | Filter selection and display', () => {
        it('( 5%) 1.  | The search bar displays the filters correctly', () => {
            cy.visit('localhost:3000')
            cy.get('.navBarContainer').within(() => {
                cy.get('.filter')
                .should(($elem) => {
                    expect($elem.text().trim()).equal('');
                })
                cy.get('.filterContainer').click()
                cy.get('.filterDetail').within(() => {
                    cy.get('#Lunch > input').check()
                    cy.get('#Dinner > input').check()
                })
                cy.get('.filter').contains('Lunch, Dinner')

                cy.get('.filterDetail').within(() => {
                    cy.get('#Chinese > input').check()
                })
                cy.get('.filter').contains('Lunch, Dinner, Chinese')

                cy.get('.filterDetail').within(() => {
                    cy.get('#Dinner > input').uncheck()
                })
                cy.get('.filter').contains('Lunch, Chinese')
            })
        })
    })
    context('(20%) 2.  | Search options', () => {
        it('(10%) 2a. | Search result is filtered according to the filter', () => {
            cy.request('localhost:4000/api/getSearch?mealFilter[]=Lunch')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(16)
            })
            cy.request('localhost:4000/api/getSearch?priceFilter[]=1&priceFilter[]=3')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(12)
            })
            cy.request('localhost:4000/api/getSearch?priceFilter[]=1&typeFilter[]=Thai')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(1)
            })

        })
        it('(10%) 2b. | Search result is sorted according to the sort method', () => {
            cy.request('localhost:4000/api/getSearch?sortBy=price')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(19)
                expect(res.body.contents[ 0].price).to.eq(1)
                expect(res.body.contents[18].price).to.eq(3)
            })
            cy.request('localhost:4000/api/getSearch?sortBy=distance')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(19)
                expect(res.body.contents[ 0].distance).to.eq(0)
                expect(res.body.contents[18].distance).to.eq(3023560)
            })
        })
    })
})
