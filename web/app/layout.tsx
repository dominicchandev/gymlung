import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "GymLung — 你食咗啲乜",
  description:
    "The Hong Kong food tracking app that roasts you for eating trash food.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="zh-HK">
      <body>{children}</body>
    </html>
  );
}
