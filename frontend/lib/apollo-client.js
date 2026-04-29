import { ApolloClient, HttpLink, InMemoryCache } from "@apollo/client";

const graphqlUrl =
  process.env.NEXT_PUBLIC_GRAPHQL_URL ?? "http://localhost:8080/graphql";
const apiToken = process.env.NEXT_PUBLIC_API_TOKEN;

const client = new ApolloClient({
  link: new HttpLink({
    uri: graphqlUrl,
    headers: apiToken ? { Authorization: `Bearer ${apiToken}` } : undefined
  }),
  cache: new InMemoryCache()
});

export default client;
