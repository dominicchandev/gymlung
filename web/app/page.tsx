export default function Home() {
  return (
    <main
      style={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "2rem",
        textAlign: "center",
      }}
    >
      <h1
        style={{
          fontSize: "3.5rem",
          fontWeight: 800,
          letterSpacing: "-0.03em",
          marginBottom: "0.5rem",
        }}
      >
        CaLoMei
      </h1>

      <p
        style={{
          fontSize: "1.25rem",
          color: "var(--muted)",
          maxWidth: "420px",
          marginBottom: "2rem",
          lineHeight: 1.5,
        }}
      >
        你食咗啲乜？The food tracking app that roasts you for eating trash food.
      </p>

      <p
        style={{
          fontSize: "1rem",
          color: "var(--muted)",
          marginBottom: "3rem",
        }}
      >
        Coming soon to the App Store.
      </p>

      <nav style={{ display: "flex", gap: "1.5rem", fontSize: "0.875rem" }}>
        <a href="/privacy-policy">Privacy Policy</a>
      </nav>
    </main>
  );
}
