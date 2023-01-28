import fs from 'fs'
import { createServer } from 'node:http';
import { WebSocketServer } from 'ws'
import { createSchema, createYoga, createPubSub } from 'graphql-yoga';
import { useServer } from 'graphql-ws/lib/use/ws'

// resolvers
import Query from "./resolvers/Query.js";
import Mutation from "./resolvers/Mutation.js";
import Subscription from "./resolvers/Subscription.js";
import DateResolver from "./resolvers/Date.js";
import CategoryResolver from "./resolvers/Category.js";
// db
import itemModel from "./models/item.js";

const pubSub = createPubSub();

const yoga = createYoga({
  schema: createSchema({
    typeDefs: fs.readFileSync(
      './src/schema.graphql',
      'utf-8'
    ),
    resolvers: {
      Query,
      Mutation,
      Subscription,
      Date: DateResolver,
      Category: CategoryResolver,
    },
  }),
  context: {
    pubSub,
    itemModel
  },
  graphiql: {
    subscriptionsProtocol: 'WS'
  }
})

const httpServer = createServer(yoga)

const wsServer = new WebSocketServer({
  server: httpServer,
  path: yoga.graphqlEndpoint,
})

useServer(
  {
    execute: (args) => args.rootValue.execute(args),
    subscribe: (args) => args.rootValue.subscribe(args),
    onSubscribe: async (ctx, msg) => {
      const { schema, execute, subscribe, contextFactory, parse, validate } =
        yoga.getEnveloped({
          ...ctx,
          req: ctx.extra.request,
          socket: ctx.extra.socket,
          params: msg.payload
        })

      const args = {
        schema,
        operationName: msg.payload.operationName,
        document: parse(msg.payload.query),
        variableValues: msg.payload.variables,
        contextValue: await contextFactory(),
        rootValue: {
          execute,
          subscribe
        }
      }

      const errors = validate(args.schema, args.document)
      if (errors.length) return errors
      return args
    },
  },
  wsServer,
)

export default httpServer;