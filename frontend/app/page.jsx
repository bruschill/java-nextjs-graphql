"use client";

import { gql, useQuery } from "@apollo/client";
import { ApolloProvider } from "@apollo/client/react";
import client from "../lib/apollo-client";

const HELLO_QUERY = gql`
  query Hello($name: String) {
    hello(name: $name)
    me {
      username
      authenticated
      roles
    }
  }
`;

function HomeContent() {
  const { data, loading, error } = useQuery(HELLO_QUERY, {
    variables: { name: "Next.js" }
  });

  return (
    <main>
      <h1>Java + Next.js + GraphQL Skeleton</h1>
      <p>Frontend: Next.js + Apollo Client</p>
      <p>Backend: Spring Boot + Spring GraphQL</p>

      {loading && <p>Loading greeting from backend...</p>}
      {error && <p>GraphQL error: {error.message}</p>}
      {data && <p>Response: {data.hello}</p>}
      {data?.me && (
        <div>
          <p>Current user: {data.me.username}</p>
          <p>Authenticated: {data.me.authenticated ? "yes" : "no"}</p>
          <p>Roles: {data.me.roles.length ? data.me.roles.join(", ") : "(none)"}</p>
        </div>
      )}
    </main>
  );
}

export default function HomePage() {
  return (
    <ApolloProvider client={client}>
      <HomeContent />
    </ApolloProvider>
  );
}
