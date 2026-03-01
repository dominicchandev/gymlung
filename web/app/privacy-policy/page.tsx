export default function PrivacyPolicy() {
  return (
    <main
      style={{
        maxWidth: "680px",
        margin: "0 auto",
        padding: "3rem 1.5rem",
        lineHeight: 1.8,
      }}
    >
      <a
        href="/"
        style={{
          display: "inline-block",
          marginBottom: "2rem",
          fontSize: "0.875rem",
        }}
      >
        &larr; Back
      </a>

      <h1
        style={{
          fontSize: "2rem",
          fontWeight: 700,
          marginBottom: "0.5rem",
        }}
      >
        Privacy Policy
      </h1>

      <p style={{ color: "var(--muted)", marginBottom: "2rem" }}>
        Last updated: February 28, 2026
      </p>

      <Section title="Overview">
        CaLoMei (&quot;we&quot;, &quot;our&quot;, or &quot;the app&quot;) is a
        food tracking application. We are committed to protecting your privacy.
        This policy explains what data we collect and how we use it.
      </Section>

      <Section title="Data We Collect">
        <ul style={{ paddingLeft: "1.25rem" }}>
          <li>
            <strong>Profile information</strong> — name, age, weight, height,
            and fitness goals you provide during onboarding.
          </li>
          <li>
            <strong>Food log entries</strong> — meals and nutritional data you
            log in the app.
          </li>
          <li>
            <strong>Photos</strong> — images you optionally capture for food
            scanning. These are processed for nutritional analysis and are not
            stored on our servers permanently.
          </li>
          <li>
            <strong>Purchase data</strong> — managed by Apple and RevenueCat for
            in-app subscriptions. We do not have access to your payment details.
          </li>
        </ul>
      </Section>

      <Section title="How We Use Your Data">
        Your data is used solely to provide the app&apos;s core functionality:
        tracking your food intake, calculating nutritional information, and
        displaying personalized insights. We do not sell your personal data to
        third parties.
      </Section>

      <Section title="Third-Party Services">
        <ul style={{ paddingLeft: "1.25rem" }}>
          <li>
            <strong>Supabase</strong> — for data storage and authentication.
          </li>
          <li>
            <strong>RevenueCat</strong> — for managing in-app subscriptions.
          </li>
          <li>
            <strong>OpenAI / AI services</strong> — for food image analysis.
            Images sent for analysis are not retained after processing.
          </li>
        </ul>
      </Section>

      <Section title="Data Storage &amp; Security">
        Your data is stored securely using Supabase with row-level security
        policies. Data is transmitted over HTTPS. We retain your data for as
        long as your account is active.
      </Section>

      <Section title="Your Rights">
        You can request deletion of your account and all associated data at any
        time by contacting us. Upon deletion, all your personal data will be
        permanently removed from our systems.
      </Section>

      <Section title="Children&apos;s Privacy">
        CaLoMei is not intended for children under 13. We do not knowingly
        collect data from children under 13.
      </Section>

      <Section title="Changes to This Policy">
        We may update this privacy policy from time to time. We will notify you
        of any changes by posting the new policy on this page.
      </Section>

      <Section title="Contact Us">
        If you have questions about this privacy policy, please contact us at{" "}
        <a href="mailto:support@calomei.app">support@calomei.app</a>.
      </Section>
    </main>
  );
}

function Section({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section style={{ marginBottom: "2rem" }}>
      <h2
        style={{
          fontSize: "1.25rem",
          fontWeight: 600,
          marginBottom: "0.5rem",
        }}
      >
        {title}
      </h2>
      <div style={{ color: "var(--muted)" }}>{children}</div>
    </section>
  );
}
