describe('111-1 WP Hackathon 2 Public Test\n  (30%) Part I - Basic Search', () => {
    beforeEach(() => {
        cy.wait(200);
    })
    context('(5%) 1. Navigation to search page', () => {
        it('( 5%) 1.  | Clicking Search Button navigates the user to /search page', () => {
            cy.visit('localhost:3000')
            cy.get('.searchContainer button').click()
            cy.url().should('eq', 'http://localhost:3000/search')
        })
    })
    context('(10%) 2. Search page front-end', () => {
        it('(10%) 2.  | Search page structure is the same as spec', () => {
            cy.visit('localhost:3000')
            cy.get('.searchContainer button').click()

            cy.get('.searchPageContainer').within(() => {
                cy.get('div[id="0"]')
                .should('have.class', 'resBlock')
                .should('have.id', '0')
                .within(() => {
                    cy.get('div').eq(0)
                    .should('have.class', 'resImgContainer')
                    .within(() => {
                        cy.get('img')
                        .should('have.class', 'resImg')
                        .should('have.attr', 'src', 'https://i.imgur.com/E7RZj9d.png')
                    })
                    cy.get('div').eq(1)
                    .should('have.class', 'resInfo')
                    .within(() => {
                        cy.get('div')
                        .should('have.class', 'title')
                        .within(() => {
                            cy.get('p').eq(0)
                            .should('have.class', 'name')
                            .contains('合益佳雞肉飯')
                            cy.get('p').eq(1)
                            .should('have.class', 'price')
                            .contains('$')
                            cy.get('p').eq(2)
                            .should('have.class', 'distance')
                            .contains('0.6 km')
                        })
                        .next('p')
                        .should('have.class', 'description')
                        .contains('Lunch, Dinner, Chinese')
                    })
                })
            })
        })
    })
    context('(15%) 3. Query and display search result', () => {
        it('(10%) 3a. | /api/getSearch returns search results', () => {
            cy.request('localhost:4000/api/getSearch')
            .then((res) => {
                expect(res.status).to.eq(200)
                expect(res.body).to.have.property('contents')
                expect(res.body.contents).to.have.length(19)
                expect(res.body.contents[2]).to.have.property('id')
                let restaurant = res.body.contents.filter((item) => item.id === 5)[0]
                expect(restaurant).to.have.property('name')
                expect(restaurant).to.have.property('tag')
                expect(restaurant).to.have.property('img')
                expect(restaurant).to.have.property('time')
                expect(restaurant).to.have.property('distance')
                expect(restaurant).to.have.property('price')

                expect(restaurant.name).to.eq('雪球咖啡')

                expect(restaurant.tag).to.have.length(2)
                expect(restaurant.tag[0]).to.equal('Breakfast')
                expect(restaurant.tag[1]).to.equal('American')

                expect(restaurant.img).to.equal('https://i.imgur.com/LTen3ml.png')

                expect(Object.keys(restaurant.time).length).to.eq(6)
                expect(restaurant.time).to.have.property('Mon')
                expect(restaurant.time).to.have.property('Tue')
                expect(restaurant.time).to.have.property('Thr')
                expect(restaurant.time).to.have.property('Fri')
                expect(restaurant.time).to.have.property('Sat')
                expect(restaurant.time).to.have.property('Sun')
                expect(restaurant.time['Mon']).to.eq('06:30-15:00')
                expect(restaurant.time['Tue']).to.eq('06:30-15:00')
                expect(restaurant.time['Thr']).to.eq('06:30-15:00')
                expect(restaurant.time['Fri']).to.eq('06:30-15:00')
                expect(restaurant.time['Sat']).to.eq('06:30-15:00')
                expect(restaurant.time['Sun']).to.eq('06:30-15:00')

                expect(restaurant.distance).to.eq(1200)
                expect(restaurant.price).to.eq(1)
            })
        })
        it('( 5%) 3b. | Search page shows result from backend', () => {
            cy.visit('localhost:3000')
            cy.get('.searchContainer button').click()

            cy.get('.searchPageContainer').within(() => {
                cy.get('div[id="5"]').within(() => {
                    cy.get('.resImg').should('have.attr', 'src', 'https://i.imgur.com/LTen3ml.png')
                    cy.get('.title').contains('雪球咖啡')
                    cy.get('.price').contains('$')
                    cy.get('.distance').contains('1.2 km')
                    cy.get('.description').contains('Breakfast, American')
                })
            })
        })
    })
})