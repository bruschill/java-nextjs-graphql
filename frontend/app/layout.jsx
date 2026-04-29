export const metadata = {
  title: "Java + Next.js + GraphQL",
  description: "Skeleton full-stack app"
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body style={{ fontFamily: "sans-serif", margin: "2rem" }}>{children}</body>
    </html>
  );
}
